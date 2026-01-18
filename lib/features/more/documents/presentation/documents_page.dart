import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_empty_view.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_loading_shimmer.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/features/more/documents/documents_providers.dart';
import 'package:estate_app/features/more/documents/models/document_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class DocumentsPage extends ConsumerWidget {
  const DocumentsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              return _DocumentTile(document: items[index]);
            },
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

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to open document.')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: ListTile(
        title: Text(document.title ?? document.fileName ?? 'Document'),
        subtitle: Text(document.type ?? 'File'),
        trailing: const Icon(Icons.open_in_new),
        onTap: () => _openDocument(context, ref),
      ),
    );
  }
}
