import 'dart:async';

import 'package:estate_app/app/routes/app_routes.dart';
import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/errors/failure_localization.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_button.dart';
import 'package:estate_app/core/presentation/widgets/app_empty_state.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_loader.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/app_text_field.dart';
import 'package:estate_app/features/properties/presentation/controllers/properties_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PropertiesPage extends StatelessWidget {
  const PropertiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _PropertiesView();
  }
}

class _PropertiesView extends StatefulWidget {
  const _PropertiesView();

  @override
  State<_PropertiesView> createState() => _PropertiesViewState();
}

class _PropertiesViewState extends State<_PropertiesView> {
  late final PropertiesController controller;
  late final ScrollController scrollController;
  late final TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    controller = Get.find<PropertiesController>();
    scrollController = ScrollController()..addListener(_onScroll);
    searchController = TextEditingController();
  }

  void _onScroll() {
    if (!scrollController.hasClients) return;
    if (scrollController.position.extentAfter < 250) {
      unawaited(controller.loadMore());
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final items = controller.items;
      final isFirstLoading =
          controller.isLoadingFirstPage.value && items.isEmpty;
      final initialFailure = controller.initialFailure.value;

      return AppScaffold(
        appBar: AppBar(title: Text(context.l10n.propertiesTitle)),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Get.toNamed<void>(Routes.propertyCreate);
            unawaited(controller.refreshList());
          },
          backgroundColor: AppColors.brand,
          child: const Icon(Icons.add, color: Colors.white),
        ),
        body: Column(
          children: [
            AppTextField(
              controller: searchController,
              labelText: context.l10n.commonSearch,
              hintText: context.l10n.propertiesSearchHint,
              onChanged: controller.setQuery,
              semanticsLabel: context.l10n.commonSearch,
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                context.l10n.propertiesCount(items.length),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Builder(
                builder: (_) {
                  if (isFirstLoading) {
                    return const Center(child: AppLoader());
                  }

                  if (initialFailure != null && items.isEmpty) {
                    return AppErrorView(
                      title: context.l10n.errorSomethingWentWrong,
                      message: initialFailure.localizedMessage(context.l10n),
                      retryLabel: context.l10n.commonRetry,
                      onRetry: () => unawaited(controller.loadInitial()),
                    );
                  }

                  if (items.isEmpty) {
                    return AppEmptyState(
                      title: context.l10n.emptyTitle,
                      message: context.l10n.emptyBody,
                      action: AppButton(
                        label: context.l10n.commonRetry,
                        variant: AppButtonVariant.secondary,
                        onPressed: () => unawaited(controller.loadInitial()),
                      ),
                    );
                  }

                  final refreshFailure = controller.refreshFailure.value;

                  return Column(
                    children: [
                      if (refreshFailure != null) ...[
                        Text(
                          refreshFailure.localizedMessage(context.l10n),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.error,
                              ),
                        ),
                        const SizedBox(height: 8),
                      ],
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: controller.refreshList,
                          child: ListView.builder(
                            controller: scrollController,
                            itemCount: items.length + 1,
                            itemBuilder: (context, index) {
                              if (index == items.length) {
                                final loadMoreFailure =
                                    controller.loadMoreFailure.value;

                                if (controller.isLoadingMore.value) {
                                  return const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    child: Center(child: AppLoader()),
                                  );
                                }

                                if (loadMoreFailure != null) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          loadMoreFailure.localizedMessage(
                                            context.l10n,
                                          ),
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.error,
                                              ),
                                        ),
                                        const SizedBox(height: 8),
                                        AppButton(
                                          label: context.l10n.commonRetry,
                                          variant: AppButtonVariant.secondary,
                                          onPressed: () =>
                                              unawaited(controller.loadMore()),
                                        ),
                                      ],
                                    ),
                                  );
                                }

                                if (!controller.hasMore.value) {
                                  return const SizedBox(height: 16);
                                }

                                return const SizedBox.shrink();
                              }

                              final property = items[index];
                              final rent = NumberFormat.currency(
                                locale: 'en_IN',
                                symbol: '₹',
                                decimalDigits: 0,
                              ).format(property.monthlyRentInr);

                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                child: ListTile(
                                  onTap: () async {
                                    await Get.toNamed<void>(
                                      Routes.propertyDetail.replaceFirst(
                                        ':id',
                                        property.id.toString(),
                                      ),
                                    );
                                    unawaited(controller.refreshList());
                                  },
                                  title: Text(property.displayName),
                                  subtitle: Text(
                                    '${property.fullAddress}\n$rent/month',
                                  ),
                                  isThreeLine: true,
                                  trailing: const Icon(
                                    Icons.chevron_right,
                                    color: AppColors.brand,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
