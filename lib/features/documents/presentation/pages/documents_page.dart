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
import 'package:estate_app/features/documents/domain/entities/document.dart';
import 'package:estate_app/features/documents/presentation/controllers/documents_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class DocumentsPage extends StatelessWidget {
  const DocumentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _DocumentsView();
  }
}

class _DocumentsView extends StatefulWidget {
  const _DocumentsView();

  @override
  State<_DocumentsView> createState() => _DocumentsViewState();
}

class _DocumentsViewState extends State<_DocumentsView> {
  late final DocumentsController controller;
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    controller = Get.find<DocumentsController>();
    scrollController = ScrollController()..addListener(_onScroll);
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final items = controller.items;
      final isLoading = controller.isLoading.value && items.isEmpty;
      final failure = controller.failure.value;

      return AppScaffold(
        appBar: AppBar(
          title: const Text('Documents'),
          actions: [
            if (controller.hasActiveFilters)
              IconButton(
                icon: const Icon(Icons.filter_alt_off),
                onPressed: controller.clearFilters,
              ),
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () => _showFilterSheet(context),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await Get.toNamed<Document>(Routes.documentUpload);
            if (result != null) {
              unawaited(controller.refresh());
            }
          },
          backgroundColor: AppColors.brand,
          child: const Icon(Icons.upload, color: Colors.white),
        ),
        body: Builder(
          builder: (_) {
            if (isLoading) {
              return const Center(child: AppLoader());
            }

            if (failure != null && items.isEmpty) {
              return AppErrorView(
                title: context.l10n.errorSomethingWentWrong,
                message: failure.localizedMessage(context.l10n),
                retryLabel: context.l10n.commonRetry,
                onRetry: () => unawaited(controller.loadDocuments()),
              );
            }

            if (items.isEmpty) {
              return AppEmptyState(
                icon: Icons.folder_open_outlined,
                title: 'No Documents',
                message:
                    'No documents found. Upload a document to get started.',
                action: AppButton(
                  label: 'Upload Document',
                  onPressed: () => Get.toNamed<void>(Routes.documentUpload),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: controller.refresh,
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: items.length + 1,
                itemBuilder: (context, index) {
                  if (index == items.length) {
                    if (controller.isLoadingMore.value) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(child: AppLoader()),
                      );
                    }
                    return const SizedBox(height: 16);
                  }

                  final document = items[index];
                  return _DocumentCard(
                    document: document,
                    onTap: () => _openDocument(document),
                    onDelete: () => _confirmDelete(context, document),
                  );
                },
              ),
            );
          },
        ),
      );
    });
  }

  Future<void> _openDocument(Document document) async {
    final url = await controller.getDownloadUrl(document.id);
    if (url != null) {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        unawaited(launchUrl(uri, mode: LaunchMode.externalApplication));
      }
    }
  }

  void _confirmDelete(BuildContext context, Document document) {
    unawaited(showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Document'),
        content: Text(
          'Are you sure you want to delete "${document.fileName}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              unawaited(controller.deleteDocument(document.id));
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    ));
  }

  void _showFilterSheet(BuildContext context) {
    unawaited(showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Filter Documents',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      controller.clearFilters();
                      Navigator.pop(context);
                    },
                    child: const Text('Clear All'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Document Type',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: DocumentType.values.map((type) {
                  return _FilterChip(
                    label: type.displayName,
                    isSelected: controller.filterType.value == type,
                    onTap: () {
                      controller.setTypeFilter(type);
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    ));
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: AppColors.brand.withValues(alpha: 0.2),
      checkmarkColor: AppColors.brand,
    );
  }
}

class _DocumentCard extends StatelessWidget {
  const _DocumentCard({
    required this.document,
    required this.onTap,
    required this.onDelete,
  });

  final Document document;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, yyyy');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: document.documentType.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  document.isPdf
                      ? Icons.picture_as_pdf
                      : document.isImage
                          ? Icons.image
                          : document.documentType.icon,
                  color: document.documentType.color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      document.fileName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: document.documentType.color
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            document.documentType.displayName,
                            style: TextStyle(
                              fontSize: 11,
                              color: document.documentType.color,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        if (document.formattedFileSize.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          Text(
                            document.formattedFileSize,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (document.propertyTitle != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.apartment,
                            size: 14,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              document.propertyTitle!,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (document.uploadedAt != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Uploaded ${dateFormat.format(document.uploadedAt!)}',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                    if (document.isExpired) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.warning,
                            size: 14,
                            color: Colors.red,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Expired',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.red[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ] else if (document.isExpiringSoon) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.schedule,
                            size: 14,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Expiring soon',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.orange[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  if (value == 'delete') {
                    onDelete();
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
