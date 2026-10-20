import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/presentation/errors/user_facing_message.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_loading_shimmer.dart';
import 'package:estate_app/core/presentation/widgets/feedback.dart';
import 'package:estate_app/features/properties/models/property.dart';
import 'package:estate_app/features/properties/presentation/pages/property_map_page.dart';
import 'package:estate_app/features/properties/presentation/widgets/property_overview_tab.dart';
import 'package:estate_app/features/properties/presentation/widgets/property_records_tabs.dart';
import 'package:estate_app/features/properties/presentation/widgets/property_text.dart';
import 'package:estate_app/features/properties/properties_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// One property: its name as the title, then tabs for the overview and the
/// records linked to it (leases, rent, expenses, maintenance, documents,
/// inspections).
class PropertyDetailPage extends ConsumerStatefulWidget {
  const PropertyDetailPage({super.key, required this.propertyId});

  final String propertyId;

  @override
  ConsumerState<PropertyDetailPage> createState() => _PropertyDetailPageState();
}

class _PropertyDetailPageState extends ConsumerState<PropertyDetailPage> {
  bool _archiving = false;

  Future<void> _reload() async {
    ref.invalidate(propertyDetailProvider(widget.propertyId));
    try {
      await ref.read(propertyDetailProvider(widget.propertyId).future);
    } catch (_) {}
  }

  /// The backend has no delete route for a managed property. Archiving sets
  /// `management_status` to `archived`: the property leaves the active lists
  /// and keeps its history.
  Future<void> _archive() async {
    final l10n = context.l10n;
    final confirmed = await context.confirm(
      title: l10n.propertyArchiveConfirmTitle,
      message: l10n.propertyArchiveConfirmBody,
      confirmLabel: l10n.propertyArchiveAction,
      destructive: true,
    );
    if (!confirmed || !mounted) return;
    setState(() => _archiving = true);
    try {
      await ref.read(propertiesRepositoryProvider).update(widget.propertyId, {
        'management_status': ManagedPropertyStatus.archived.wire,
      });
      if (!mounted) return;
      ref
        ..invalidate(propertiesListProvider)
        ..invalidate(propertyTitlesProvider)
        ..invalidate(propertiesPagedProvider)
        ..invalidate(propertyDetailProvider(widget.propertyId));
      context.showSnack(l10n.propertyArchived);
      context.go('/properties');
    } catch (error) {
      if (mounted) {
        context.showSnack(l10n.propertyArchiveFailed(userFacingMessage(error)));
      }
    } finally {
      if (mounted) setState(() => _archiving = false);
    }
  }

  void _openMap(Property property) {
    context.go(
      '/properties/map?lat=${property.latitude}&lng=${property.longitude}',
      extra: [
        PropertyMarker(
          id: '${property.id}',
          label: propertyName(property, context.l10n),
          latitude: property.latitude!,
          longitude: property.longitude!,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final detailAsync = ref.watch(propertyDetailProvider(widget.propertyId));
    final detail = detailAsync.valueOrNull;
    final property = detail?.property;
    final hasPoint = property?.latitude != null && property?.longitude != null;

    final tabs = [
      l10n.propertyTabOverview,
      l10n.propertyTabLease,
      l10n.propertyTabRent,
      l10n.propertyTabExpenses,
      l10n.propertyTabMaintenance,
      l10n.propertyTabDocuments,
      l10n.propertyTabInspections,
    ];

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            property == null
                ? l10n.propertyDetailTitle
                : propertyName(property, l10n),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          actions: [
            IconButton(
              tooltip: l10n.propertyEdit,
              icon: const Icon(Icons.edit_outlined),
              onPressed: () =>
                  context.go('/properties/${widget.propertyId}/edit'),
            ),
            PopupMenuButton<void>(
              tooltip: l10n.propertyMoreActions,
              enabled: !_archiving,
              icon: _archiving
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.more_vert_rounded),
              itemBuilder: (context) => [
                if (property != null && hasPoint)
                  PopupMenuItem(
                    onTap: () => _openMap(property),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.map_outlined),
                      title: Text(l10n.propertyShowOnMap),
                    ),
                  ),
                PopupMenuItem(
                  onTap: _archive,
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      Icons.archive_outlined,
                      color: context.colors.error,
                    ),
                    title: Text(
                      l10n.propertyArchive,
                      style: TextStyle(color: context.colors.error),
                    ),
                  ),
                ),
              ],
            ),
          ],
          bottom: detail == null
              ? null
              : TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  tabs: [for (final tab in tabs) Tab(text: tab)],
                ),
        ),
        body: detailAsync.when(
          loading: () => const AppLoadingShimmer(itemCount: 3, itemHeight: 140),
          error: (error, _) => RefreshIndicator(
            onRefresh: _reload,
            child: StateScrollView(
              child: AppErrorView(
                title: l10n.commonLoadFailedTitle,
                message: userFacingMessage(error),
                onRetry: _reload,
              ),
            ),
          ),
          data: (detail) {
            final id = detail.property.id ?? int.parse(widget.propertyId);
            return TabBarView(
              children: [
                PropertyOverviewTab(detail: detail, onRefresh: _reload),
                PropertyLeaseTab(
                  propertyId: id,
                  activeLease: detail.activeLease,
                ),
                PropertyRentTab(propertyId: id),
                PropertyExpensesTab(propertyId: id),
                PropertyMaintenanceTab(propertyId: id),
                PropertyDocumentsTab(propertyId: id),
                PropertyInspectionsTab(propertyId: id),
              ],
            );
          },
        ),
      ),
    );
  }
}
