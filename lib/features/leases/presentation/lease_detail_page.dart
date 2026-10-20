import 'package:cross_file/cross_file.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/errors/user_facing_message.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_loading_shimmer.dart';
import 'package:estate_app/core/presentation/widgets/feedback.dart';
import 'package:estate_app/features/leases/leases_providers.dart';
import 'package:estate_app/features/leases/models/lease.dart';
import 'package:estate_app/features/leases/presentation/widgets/lease_dialogs.dart';
import 'package:estate_app/features/leases/presentation/widgets/lease_sections.dart';
import 'package:estate_app/features/more/documents/documents_providers.dart';
import 'package:estate_app/features/properties/properties_providers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class LeaseDetailPage extends ConsumerStatefulWidget {
  const LeaseDetailPage({super.key, required this.leaseId});

  final String leaseId;

  @override
  ConsumerState<LeaseDetailPage> createState() => _LeaseDetailPageState();
}

class _LeaseDetailPageState extends ConsumerState<LeaseDetailPage> {
  bool _busy = false;

  void _refresh() {
    ref
      ..invalidate(leaseDetailProvider(widget.leaseId))
      ..invalidate(leasesListProvider)
      ..invalidate(leaseTenantNamesProvider);
  }

  /// Runs one lease action with the screen busy, then refreshes the lease and
  /// says how it went.
  Future<void> _run(Future<void> Function() action, String done) async {
    setState(() => _busy = true);
    try {
      await action();
      _refresh();
      if (mounted) context.showSnack(done);
    } catch (error) {
      if (mounted) context.showSnack(userFacingMessage(error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  /// Picks a PDF. The file goes through the documents route, then the lease
  /// links to that document (`upload-signed` with `lease_document_id`).
  Future<void> _uploadSigned() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['pdf'],
      withData: kIsWeb,
    );
    final picked = result?.files.singleOrNull;
    if (picked == null || !mounted) return;
    final XFile file;
    if (picked.path != null) {
      file = XFile(picked.path!);
    } else if (picked.bytes != null) {
      file = XFile.fromData(picked.bytes!, name: picked.name);
    } else {
      return;
    }
    await _run(
      () =>
          ref.read(leasesRepositoryProvider).uploadSigned(widget.leaseId, file),
      context.l10n.leaseUploaded,
    );
  }

  /// Opens the signed lease through the signed download route. A stored
  /// document is private, so its `file_url` is not used.
  Future<void> _viewDocument(int documentId) async {
    var message = context.l10n.leaseOpenFailed;
    try {
      final url = await ref
          .read(documentsRepositoryProvider)
          .fetchDownloadUrl(documentId);
      final uri = url == null ? null : Uri.tryParse(url);
      if (uri != null &&
          await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        return;
      }
    } catch (error) {
      // The backend answers 403 when the caller may not open the file.
      message = userFacingMessage(error);
    }
    if (mounted) context.showSnack(message);
  }

  Future<void> _renew(Lease lease) async {
    final request = await showRenewDialog(context, lease);
    if (request == null || !mounted) return;
    await _run(
      () => ref.read(leasesRepositoryProvider).renew(widget.leaseId, request),
      context.l10n.leaseRenewed,
    );
  }

  Future<void> _terminate() async {
    final request = await showTerminateDialog(context);
    if (request == null || !mounted) return;
    await _run(
      () =>
          ref.read(leasesRepositoryProvider).terminate(widget.leaseId, request),
      context.l10n.leaseTerminated,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final leaseAsync = ref.watch(leaseDetailProvider(widget.leaseId));
    final titles =
        ref.watch(propertyTitlesProvider).valueOrNull ?? const <int, String>{};

    return Scaffold(
      appBar: AppBar(title: Text(l10n.leaseDetailTitle)),
      body: leaseAsync.when(
        loading: () => const AppLoadingShimmer(itemCount: 4, itemHeight: 140),
        error: (error, _) => AppErrorView(
          title: l10n.commonLoadFailedTitle,
          message: userFacingMessage(error),
          onRetry: () => ref.invalidate(leaseDetailProvider(widget.leaseId)),
        ),
        data: (lease) {
          const gap = SizedBox(height: AppSpacing.md);
          final documentId = lease.leaseDocumentId;
          return RefreshIndicator(
            onRefresh: () async {
              _refresh();
              await ref
                  .read(leaseDetailProvider(widget.leaseId).future)
                  .catchError((_) => lease);
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                LeaseHeader(
                  lease: lease,
                  propertyTitle: titles[lease.propertyId],
                ),
                gap,
                LeaseTermSection(lease: lease),
                gap,
                LeaseTenantSection(lease: lease),
                gap,
                LeaseCollectionSection(lease: lease),
                gap,
                LeaseDocumentSection(
                  documentId: documentId,
                  busy: _busy,
                  onUpload: _uploadSigned,
                  onView: () => _viewDocument(documentId!),
                ),
                // Only the actions the backend accepts for this status.
                if (lease.canRenew) ...[
                  const SizedBox(height: AppSpacing.xl),
                  FilledButton.icon(
                    onPressed: _busy ? null : () => _renew(lease),
                    icon: const Icon(Icons.autorenew_rounded),
                    label: Text(l10n.leaseRenew),
                  ),
                ],
                if (lease.canTerminate) ...[
                  SizedBox(
                    height: lease.canRenew ? AppSpacing.sm : AppSpacing.xl,
                  ),
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      foregroundColor: context.colors.error,
                    ),
                    onPressed: _busy ? null : _terminate,
                    icon: const Icon(Icons.logout_rounded),
                    label: Text(l10n.leaseTerminate),
                  ),
                ],
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          );
        },
      ),
    );
  }
}
