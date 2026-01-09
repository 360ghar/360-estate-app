import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:estate_app/app/routes/app_routes.dart';
import 'package:estate_app/core/presentation/widgets/app_card.dart';
import 'package:estate_app/core/presentation/widgets/app_empty_state.dart';
import 'package:estate_app/core/presentation/widgets/app_loader.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/features/properties/domain/entities/property.dart';
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

class _PropertiesView extends GetView<PropertiesController> {
  const _PropertiesView();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: const Text('Properties'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchSheet(context),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoadingFirstPage.value && controller.items.isEmpty) {
          return const Center(child: AppLoader());
        }

        if (controller.initialFailure.value != null &&
            controller.items.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.initialFailure.value!.message,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => unawaited(controller.loadInitial()),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (controller.items.isEmpty) {
          return const AppEmptyState(
            icon: Icons.business_outlined,
            title: 'No properties found',
            message: 'Start by adding your first property',
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshList,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount:
                controller.items.length + (controller.hasMore.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == controller.items.length) {
                unawaited(controller.loadMore());
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: AppLoader(),
                  ),
                );
              }

              final property = controller.items[index];
              return _PropertyCard(property: property);
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        heroTag: 'properties_fab',
        onPressed: () => Get.toNamed<void>(Routes.propertyCreate),
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showSearchSheet(BuildContext context) {
    final searchController =
        TextEditingController(text: controller.query.value);

    unawaited(
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (context) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search properties...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => controller.setQuery(value),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _PropertyCard extends StatelessWidget {
  const _PropertyCard({required this.property});

  final Property property;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 0);

    return AppCard(
      padding: EdgeInsets.zero,
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => Get.toNamed<void>(
          Routes.propertyDetail.replaceFirst(':id', property.id.toString()),
          arguments: property,
        ),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Property Image Placeholder
            Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Stack(
                children: [
                  if (property.images.isNotEmpty)
                    ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(16)),
                      child: CachedNetworkImage(
                        imageUrl: property.images.first,
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        memCacheWidth: 400, // Optimize memory for thumbnail size
                        fadeInDuration: const Duration(milliseconds: 200),
                        placeholder: (context, url) => Container(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          child: Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            ),
                          ),
                        ),
                        errorWidget: (_, __, ___) => Center(
                          child: Icon(
                            Icons.business,
                            size: 48,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                      ),
                    )
                  else
                    Center(
                      child: Icon(
                        Icons.business,
                        size: 48,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(property.managementStatus)
                            .withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        property.managementStatus.name.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.displayName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          property.fullAddress,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      if (property.bedroomCount != null)
                        _FeatureIcon(
                          icon: Icons.king_bed_outlined,
                          label: '${property.bedroomCount} BHK',
                        ),
                      if (property.bedroomCount != null)
                        const SizedBox(width: 16),
                      if (property.floorAreaSqft != null)
                        _FeatureIcon(
                          icon: Icons.straighten_outlined,
                          label:
                              '${property.floorAreaSqft!.toStringAsFixed(0)} sqft',
                        ),
                      const Spacer(),
                      Text(
                        currencyFormat.format(property.monthlyRentInr),
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      Text(
                        ' /mo',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(ManagementStatus status) {
    return switch (status) {
      ManagementStatus.active => Colors.green,
      ManagementStatus.inactive => Colors.grey,
      ManagementStatus.sold => Colors.purple,
    };
  }
}

class _FeatureIcon extends StatelessWidget {
  const _FeatureIcon({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Theme.of(context).colorScheme.outline,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
        ),
      ],
    );
  }
}
