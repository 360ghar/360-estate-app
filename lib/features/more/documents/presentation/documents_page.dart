import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_shadows.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_empty_view.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_loading_shimmer.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/app_search_bar.dart';
import 'package:estate_app/features/more/documents/documents_providers.dart';
import 'package:estate_app/features/more/documents/models/document_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

/// Maps a file type/extension string to an icon, color pair.
({IconData icon, Color color}) _fileTypeVisual(String? type, String? fileName) {
  final t = (type ?? fileName ?? '').toLowerCase();
  if (t.contains('pdf')) {
    return (icon: Icons.picture_as_pdf_rounded, color: const Color(0xFFDC2626));
  }
  if (t.contains('image') ||
      t.contains('jpg') ||
      t.contains('jpeg') ||
      t.contains('png') ||
      t.contains('gif') ||
      t.contains('webp')) {
    return (icon: Icons.image_rounded, color: const Color(0xFF059669));
  }
  if (t.contains('doc') || t.contains('word') || t.contains('docx')) {
    return (icon: Icons.description_rounded, color: const Color(0xFF2563EB));
  }
  if (t.contains('xls') || t.contains('sheet') || t.contains('csv')) {
    return (icon: Icons.table_chart_rounded, color: const Color(0xFF059669));
  }
  return (icon: Icons.insert_drive_file_rounded, color: AppColors.textSecondary);
}

class DocumentsPage extends ConsumerStatefulWidget {
  const DocumentsPage({super.key});

  @override
  ConsumerState<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends ConsumerState<DocumentsPage> {
  String _query = '';
  String? _selectedCategory;

  List<DocumentItem> _applyFilters(List<DocumentItem> items) {
    var filtered = items;
    if (_query.isNotEmpty) {
      final q = _query.toLowerCase();
      filtered = filtered
          .where((d) =>
              (d.title ?? '').toLowerCase().contains(q) ||
              (d.fileName ?? '').toLowerCase().contains(q) ||
              (d.type ?? '').toLowerCase().contains(q))
          .toList();
    }
    if (_selectedCategory != null) {
      filtered =
          filtered.where((d) => d.type == _selectedCategory).toList();
    }
    return filtered;
  }

  Set<String> _categories(List<DocumentItem> items) {
    return items
        .map((d) => d.type)
        .whereType<String>()
        .where((t) => t.isNotEmpty)
        .toSet();
  }

  @override
  Widget build(BuildContext context) {
    final documentsAsync = ref.watch(documentsListProvider);

    return AppScaffold(
      appBar: AppBar(title: const Text('Documents')),
      padding: EdgeInsets.zero,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/more/documents/upload'),
        icon: const Icon(Icons.upload_file),
        label: const Text('Upload'),
      ),
      body: documentsAsync.when(
        data: (items) {
          if (items.isEmpty) {
            return const AppEmptyView(
              title: 'No documents yet',
              message: 'Upload agreements and receipts here.',
            );
          }

          final categories = _categories(items);
          final filtered = _applyFilters(items);

          return Column(
            children: [
              AppSearchBar(
                hintText: 'Search documents...',
                onChanged: (value) => setState(() => _query = value),
                filterChips: [
                  FilterChip(
                    label: const Text('All'),
                    selected: _selectedCategory == null,
                    onSelected: (_) =>
                        setState(() => _selectedCategory = null),
                  ),
                  ...categories.map((cat) => FilterChip(
                        label: Text(cat),
                        selected: _selectedCategory == cat,
                        onSelected: (_) => setState(
                          () => _selectedCategory =
                              _selectedCategory == cat ? null : cat,
                        ),
                      )),
                ],
              ),
              Expanded(
                child: filtered.isEmpty
                    ? const AppEmptyView(
                        title: 'No matches',
                        message: 'Try adjusting your search or filters.',
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.lg,
                          AppSpacing.sm,
                          AppSpacing.lg,
                          AppSpacing.xxxl * 2,
                        ),
                        itemCount: filtered.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: AppSpacing.md),
                        itemBuilder: (context, index) {
                          return _DocumentTile(document: filtered[index]);
                        },
                      ),
              ),
            ],
          );
        },
        loading: () => const AppLoadingShimmer(),
        error: (error, _) => AppErrorView(
          title: 'Unable to load documents',
          message: error.toString(),
          onRetry: () => ref.invalidate(documentsListProvider),
          retryLabel: 'Try again',
        ),
      ),
    );
  }
}

class _DocumentTile extends ConsumerWidget {
  const _DocumentTile({required this.document});

  final DocumentItem document;

  Future<void> _openDocument(BuildContext context, WidgetRef ref) async {
    final url = document.url ??
        await ref
            .read(documentsRepositoryProvider)
            .fetchDownloadUrl(document.id?.toString() ?? '');
    if (!context.mounted) return;
    if (url == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to open document.')),
      );
      return;
    }

    final uri = Uri.tryParse(url);
    if (uri == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid document URL.')),
      );
      return;
    }

    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!context.mounted) return;
    if (!launched) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to open document.')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;

    final visual = _fileTypeVisual(document.type, document.fileName);
    final dateStr = document.uploadedAt != null
        ? DateFormat('dd MMM yyyy').format(document.uploadedAt!)
        : null;

    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: AppRadii.lg,
        border: Border.all(
          color: isDark ? AppColors.darkCardBorder : AppColors.cardBorder,
          width: 0.5,
        ),
        boxShadow: AppShadows.cardResting,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppRadii.lg,
        child: InkWell(
          borderRadius: AppRadii.lg,
          onTap: () => _openDocument(context, ref),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                // File type icon with colored background
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: visual.color.withValues(alpha: isDark ? 0.15 : 0.1),
                    borderRadius: AppRadii.md,
                  ),
                  child: Icon(
                    visual.icon,
                    size: 22,
                    color: visual.color,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),

                // Title + metadata
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        document.title ?? document.fileName ?? 'Document',
                        style: textTheme.titleSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSpacing.xxs),
                      Row(
                        children: [
                          if (document.type != null &&
                              document.type!.isNotEmpty) ...[
                            Text(
                              document.type!.toUpperCase(),
                              style: textTheme.labelSmall?.copyWith(
                                color: visual.color,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (dateStr != null) ...[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.xs),
                                child: Text(
                                  '\u2022',
                                  style: textTheme.bodySmall?.copyWith(
                                    color: AppColors.textTertiary,
                                  ),
                                ),
                              ),
                            ],
                          ],
                          if (dateStr != null)
                            Text(
                              dateStr,
                              style: textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: AppSpacing.sm),
                Icon(
                  Icons.open_in_new_rounded,
                  size: 18,
                  color: AppColors.textTertiary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
