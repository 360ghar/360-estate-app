import 'dart:async';
import 'dart:io';

import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_shadows.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/app_section_card.dart';
import 'package:estate_app/features/more/documents/documents_providers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

const _documentCategories = [
  'Agreement',
  'Receipt',
  'Invoice',
  'ID Proof',
  'Tax',
  'Insurance',
  'Other',
];

class DocumentUploadPage extends ConsumerStatefulWidget {
  const DocumentUploadPage({super.key});

  @override
  ConsumerState<DocumentUploadPage> createState() =>
      _DocumentUploadPageState();
}

class _DocumentUploadPageState extends ConsumerState<DocumentUploadPage> {
  final _titleController = TextEditingController();
  String _selectedType = _documentCategories.last;
  File? _file;
  String? _fileName;
  int? _fileSize;
  bool _isUploading = false;
  double _uploadProgress = 0;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null || result.files.isEmpty) return;
    final platformFile = result.files.single;
    final path = platformFile.path;
    if (path == null) return;
    setState(() {
      _file = File(path);
      _fileName = platformFile.name;
      _fileSize = platformFile.size;
    });
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  IconData _fileIcon(String name) {
    final lower = name.toLowerCase();
    if (lower.endsWith('.pdf')) return Icons.picture_as_pdf_rounded;
    if (lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.png') ||
        lower.endsWith('.gif') ||
        lower.endsWith('.webp')) {
      return Icons.image_rounded;
    }
    if (lower.endsWith('.doc') || lower.endsWith('.docx')) {
      return Icons.description_rounded;
    }
    if (lower.endsWith('.xls') || lower.endsWith('.xlsx') || lower.endsWith('.csv')) {
      return Icons.table_chart_rounded;
    }
    return Icons.insert_drive_file_rounded;
  }

  Color _fileColor(String name) {
    final lower = name.toLowerCase();
    if (lower.endsWith('.pdf')) return const Color(0xFFDC2626);
    if (lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.png') ||
        lower.endsWith('.gif') ||
        lower.endsWith('.webp')) {
      return const Color(0xFF059669);
    }
    if (lower.endsWith('.doc') || lower.endsWith('.docx')) {
      return const Color(0xFF2563EB);
    }
    return AppColors.textSecondary;
  }

  Future<void> _upload() async {
    if (_file == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pick a file first.')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
      _uploadProgress = 0;
    });

    // Simulate upload progress
    _simulateProgress();

    try {
      await ref.read(documentsRepositoryProvider).upload(
            file: _file!,
            title: _titleController.text.trim(),
            type: _selectedType,
          );
      ref.invalidate(documentsListProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Document uploaded.')),
        );
        context.go('/more/documents');
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  void _simulateProgress() {
    Future.doWhile(() async {
      await Future<void>.delayed(const Duration(milliseconds: 100));
      if (!mounted || !_isUploading) return false;
      setState(() {
        _uploadProgress = (_uploadProgress + 0.05).clamp(0.0, 0.95);
      });
      return _uploadProgress < 0.95;
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;

    return AppScaffold(
      appBar: AppBar(title: const Text('Upload document')),
      scrollable: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Upload area
          GestureDetector(
            onTap: _isUploading ? null : _pickFile,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.xxl,
                horizontal: AppSpacing.lg,
              ),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurfaceSecondary
                    : AppColors.surfaceSecondary,
                borderRadius: AppRadii.lg,
                border: Border.all(
                  color: scheme.primary.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: scheme.primary.withValues(alpha: isDark ? 0.15 : 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.cloud_upload_outlined,
                      size: 28,
                      color: scheme.primary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    _file == null ? 'Tap to select a file' : 'Tap to change file',
                    style: textTheme.titleSmall?.copyWith(
                      color: scheme.primary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'PDF, images, documents up to 25 MB',
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // File preview after selection
          if (_file != null && _fileName != null) ...[
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius: AppRadii.lg,
                border: Border.all(
                  color: isDark
                      ? AppColors.darkCardBorder
                      : AppColors.cardBorder,
                  width: 0.5,
                ),
                boxShadow: AppShadows.cardResting,
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _fileColor(_fileName!)
                          .withValues(alpha: isDark ? 0.15 : 0.1),
                      borderRadius: AppRadii.sm,
                    ),
                    child: Icon(
                      _fileIcon(_fileName!),
                      size: 20,
                      color: _fileColor(_fileName!),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _fileName!,
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (_fileSize != null)
                          Text(
                            _formatFileSize(_fileSize!),
                            style: textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _isUploading
                        ? null
                        : () => setState(() {
                              _file = null;
                              _fileName = null;
                              _fileSize = null;
                            }),
                    icon: Icon(
                      Icons.close_rounded,
                      size: 18,
                      color: AppColors.textTertiary,
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: AppSpacing.xl),

          // Document details section
          AppSectionCard(
            title: 'Document details',
            icon: Icons.edit_document,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Document title',
                  hintText: 'e.g. Rental Agreement - Unit 3B',
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Category',
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: _documentCategories.map((cat) {
                  final isSelected = _selectedType == cat;
                  return ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedType = cat),
                  );
                }).toList(),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.xl),

          // Upload progress
          if (_isUploading) ...[
            ClipRRect(
              borderRadius: AppRadii.pill,
              child: LinearProgressIndicator(
                value: _uploadProgress,
                minHeight: 6,
                backgroundColor:
                    isDark ? AppColors.darkSurfaceVariant : AppColors.surfaceSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Uploading... ${(_uploadProgress * 100).toInt()}%',
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],

          // Upload button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton.icon(
              onPressed: _isUploading ? null : _upload,
              icon: _isUploading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.cloud_upload_rounded),
              label: Text(_isUploading ? 'Uploading...' : 'Upload document'),
            ),
          ),
        ],
      ),
    );
  }
}
