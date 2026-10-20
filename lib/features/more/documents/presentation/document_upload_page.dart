import 'dart:async';

import 'package:cross_file/cross_file.dart';
import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/errors/user_facing_message.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_section_card.dart';
import 'package:estate_app/core/presentation/widgets/feedback.dart';
import 'package:estate_app/core/services/file_upload_service.dart';
import 'package:estate_app/features/more/documents/documents_providers.dart';
import 'package:estate_app/features/more/documents/presentation/document_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DocumentUploadPage extends ConsumerStatefulWidget {
  const DocumentUploadPage({super.key});

  @override
  ConsumerState<DocumentUploadPage> createState() => _DocumentUploadPageState();
}

class _DocumentUploadPageState extends ConsumerState<DocumentUploadPage> {
  final _titleController = TextEditingController();
  DocumentType _type = DocumentType.other;
  XFile? _file;
  String? _fileName;
  int? _fileSize;

  /// Shown under the file picker: no file, or a file over the size cap.
  String? _fileError;
  bool _isUploading = false;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    // withData on web: browser picks have no filesystem path, so retain the
    // bytes via XFile.fromData instead of discarding the selection.
    final FilePickerResult? result;
    try {
      result = await FilePicker.platform.pickFiles(withData: kIsWeb);
    } catch (_) {
      if (mounted) {
        setState(() => _fileError = context.l10n.documentUploadPickFailed);
      }
      return;
    }
    if (result == null || result.files.isEmpty) return;
    final picked = result.files.single;
    final path = picked.path;
    final XFile file;
    if (path != null && path.isNotEmpty) {
      file = XFile(path);
    } else if (picked.bytes != null) {
      file = XFile.fromData(picked.bytes!, name: picked.name);
    } else {
      return;
    }
    if (!mounted) return;
    final tooLarge = picked.size > kMaxUploadBytes;
    setState(() {
      _file = tooLarge ? null : file;
      _fileName = tooLarge ? null : picked.name;
      _fileSize = tooLarge ? null : picked.size;
      _fileError = tooLarge ? context.l10n.documentUploadTooLarge : null;
    });
  }

  void _clearFile() => setState(() {
    _file = null;
    _fileName = null;
    _fileSize = null;
  });

  Future<void> _upload() async {
    final l10n = context.l10n;
    final file = _file;
    if (file == null) {
      setState(() => _fileError = l10n.documentUploadNoFile);
      return;
    }
    setState(() => _isUploading = true);
    try {
      final title = _titleController.text.trim();
      // A blank title is not sent: the backend uses the file name.
      await ref
          .read(documentsRepositoryProvider)
          .upload(
            file: file,
            title: title.isEmpty ? _fileName : title,
            documentType: _type,
          );
      ref
        ..invalidate(documentsListProvider)
        ..invalidate(documentsForPropertyProvider);
      if (!mounted) return;
      context.showSnack(l10n.documentUploadDone);
      context.go('/more/documents');
    } catch (error) {
      if (!mounted) return;
      context.showSnack(
        userFacingMessage(error),
        actionLabel: l10n.commonRetry,
        onAction: _upload,
      );
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final error = _fileError;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.documentUploadTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          AppSpacing.xxl,
        ),
        children: [
          _FilePicker(
            fileName: _fileName,
            bytes: _fileSize,
            error: error,
            enabled: !_isUploading,
            onPick: _pickFile,
            onClear: _clearFile,
          ),
          if (error != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                0,
              ),
              child: Semantics(
                liveRegion: true,
                child: Text(
                  error,
                  style: context.text.bodySmall?.copyWith(color: colors.error),
                ),
              ),
            ),
          const SizedBox(height: AppSpacing.md),
          AppSectionCard(
            title: l10n.documentUploadDetails,
            children: [
              TextFormField(
                controller: _titleController,
                enabled: !_isUploading,
                textInputAction: TextInputAction.done,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: l10n.documentUploadTitleLabel,
                  helperText: l10n.documentUploadTitleHelper,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(l10n.documentUploadType, style: context.text.titleSmall),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  for (final t in DocumentType.values)
                    ChoiceChip(
                      label: Text(t.text(l10n)),
                      selected: _type == t,
                      onSelected: _isUploading
                          ? null
                          : (_) => setState(() => _type = t),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          if (_isUploading) ...[
            Semantics(
              liveRegion: true,
              label: l10n.documentUploadUploading,
              child: const ClipRRect(
                borderRadius: AppRadii.xs,
                child: LinearProgressIndicator(minHeight: 6),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          FilledButton.icon(
            onPressed: _isUploading ? null : _upload,
            icon: const Icon(Icons.upload_rounded),
            label: Text(
              _isUploading
                  ? l10n.documentUploadUploading
                  : l10n.documentUploadSubmit,
            ),
          ),
        ],
      ),
    );
  }
}

/// The drop zone: what to pick and the limits, then the picked file.
class _FilePicker extends StatelessWidget {
  const _FilePicker({
    required this.fileName,
    required this.bytes,
    required this.error,
    required this.enabled,
    required this.onPick,
    required this.onClear,
  });

  final String? fileName;
  final int? bytes;
  final String? error;
  final bool enabled;
  final VoidCallback onPick;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final name = fileName;
    final size = bytes;
    final edge = error != null
        ? colors.error
        : name == null
        ? colors.outline
        : colors.primary;

    return Material(
      color: context.palette.card,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadii.lg,
        side: BorderSide(color: edge, width: error != null ? 2 : 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: enabled ? onPick : null,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: name == null
              ? Column(
                  children: [
                    const SizedBox(height: AppSpacing.md),
                    ExcludeSemantics(
                      child: Icon(
                        Icons.upload_file_rounded,
                        size: 40,
                        color: colors.primary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      l10n.documentUploadChoose,
                      style: context.text.titleLarge,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      l10n.documentUploadLimits,
                      textAlign: TextAlign.center,
                      style: context.text.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                )
              : Row(
                  children: [
                    ExcludeSemantics(
                      child: Icon(fileIcon(name), color: colors.primary),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: context.text.titleMedium,
                          ),
                          Text(
                            [
                              if (size != null) fileSize(size),
                              l10n.documentUploadChange,
                            ].join('  ·  '),
                            style: context.text.bodySmall?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: l10n.documentUploadRemoveFile,
                      onPressed: enabled ? onClear : null,
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
