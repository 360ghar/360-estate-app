import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/errors/user_facing_message.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_empty_view.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_list_card.dart';
import 'package:estate_app/core/presentation/widgets/app_loading_shimmer.dart';
import 'package:estate_app/core/presentation/widgets/app_search_bar.dart';
import 'package:estate_app/core/presentation/widgets/feedback.dart';
import 'package:estate_app/core/presentation/widgets/motion.dart';
import 'package:estate_app/core/utils/dates.dart';
import 'package:estate_app/features/more/documents/documents_providers.dart';
import 'package:estate_app/features/more/documents/models/document_item.dart';
import 'package:estate_app/features/more/documents/presentation/document_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

/// Agreements, proofs and receipts, searchable and filtered by type.
class DocumentsPage extends ConsumerStatefulWidget {
  const DocumentsPage({super.key});

  @override
  ConsumerState<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends ConsumerState<DocumentsPage> {
  String _query = '';
  DocumentType? _type;

  bool _matches(DocumentItem d) {
    if (_type != null && d.documentType != _type) return false;
    if (_query.isEmpty) return true;
    final q = _query.toLowerCase();
    return (d.title ?? '').toLowerCase().contains(q) ||
        (d.documentType?.text(context.l10n) ?? '').toLowerCase().contains(q);
  }

  Future<void> _reload() async {
    ref.invalidate(documentsListProvider);
    await ref
        .read(documentsListProvider.future)
        .catchError((_) => const <DocumentItem>[]);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final documents = ref.watch(documentsListProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.documentsTitle)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/more/documents/upload'),
        icon: const Icon(Icons.upload_file_rounded),
        label: Text(l10n.documentsUpload),
      ),
      body: RefreshIndicator(
        onRefresh: _reload,
        child: documents.when(
          loading: () => const AppLoadingShimmer(),
          error: (error, _) => StateScrollView(
            child: AppErrorView(
              title: l10n.commonLoadFailedTitle,
              message: userFacingMessage(error),
              onRetry: _reload,
            ),
          ),
          data: (items) {
            if (items.isEmpty) {
              return StateScrollView(
                child: AppEmptyView(
                  title: l10n.documentsEmptyTitle,
                  message: l10n.documentsEmptyBody,
                  icon: Icons.folder_open_outlined,
                ),
              );
            }
            final types = {for (final d in items) ?d.documentType}.toList()
              ..sort((a, b) => a.index.compareTo(b.index));
            final shown = items.where(_matches).toList();
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 96),
              children: [
                AppSearchBar(
                  hintText: l10n.documentsSearchHint,
                  onChanged: (value) => setState(() => _query = value.trim()),
                  filterChips: [
                    FilterChip(
                      label: Text(l10n.tenantsFilterAll),
                      selected: _type == null,
                      onSelected: (_) => setState(() => _type = null),
                    ),
                    for (final t in types)
                      FilterChip(
                        label: Text(t.text(l10n)),
                        selected: _type == t,
                        onSelected: (_) =>
                            setState(() => _type = _type == t ? null : t),
                      ),
                  ],
                ),
                if (shown.isEmpty)
                  AppEmptyView(
                    title: l10n.documentsNoMatchTitle,
                    message: l10n.documentsNoMatchBody,
                    icon: Icons.search_off_rounded,
                  ),
                for (var i = 0; i < shown.length; i++)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.sm,
                      AppSpacing.lg,
                      AppSpacing.xs,
                    ),
                    child: RiseIn(
                      index: i,
                      child: _DocumentRow(document: shown[i]),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _DocumentRow extends StatelessWidget {
  const _DocumentRow({required this.document});

  final DocumentItem document;

  /// `file_url` is the signed link the backend gives a viewer who may open
  /// the file. It is null for a viewer who may not.
  Future<void> _open(BuildContext context) async {
    final l10n = context.l10n;
    final uri = Uri.tryParse(document.fileUrl ?? '');
    if (uri == null || !uri.hasScheme) {
      context.showSnack(l10n.documentsNoAccess);
      return;
    }
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      context.showSnack(l10n.documentsOpenFailed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final canOpen = document.fileUrl != null && document.fileUrl!.isNotEmpty;
    final created = document.createdAt;
    final size = document.fileSize;
    final muted = context.colors.onSurfaceVariant;
    return AppListCard(
      leading: ExcludeSemantics(
        child: Icon(
          fileIcon(document.mimeType ?? document.title),
          color: muted,
        ),
      ),
      title: document.title ?? l10n.documentsUntitled,
      subtitle: (document.sharedWithTenant ?? false)
          ? l10n.documentsSharedWithTenant
          : null,
      facts: [
        ?document.documentType?.text(l10n),
        if (created != null) shortDate(context, created),
        if (size != null) fileSize(size),
      ],
      trailing: canOpen
          ? ExcludeSemantics(
              child: Icon(Icons.open_in_new_rounded, color: muted),
            )
          : Tooltip(
              message: l10n.documentsLocked,
              child: Icon(Icons.lock_outline_rounded, color: muted),
            ),
      semanticLabel: canOpen ? null : l10n.documentsLocked,
      onTap: () => _open(context),
    );
  }
}
