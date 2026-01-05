import 'dart:async';
import 'dart:io';

import 'package:estate_app/core/presentation/widgets/app_button.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/features/documents/domain/entities/document.dart';
import 'package:estate_app/features/documents/presentation/controllers/document_upload_controller.dart';
import 'package:estate_app/features/properties/domain/repositories/properties_repository.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DocumentUploadPage extends StatelessWidget {
  const DocumentUploadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _DocumentUploadView();
  }
}

class _DocumentUploadView extends StatelessWidget {
  const _DocumentUploadView();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DocumentUploadController>();
    final dateFormat = DateFormat('MMM d, yyyy');

    return AppScaffold(
      appBar: AppBar(
        title: const Text('Upload Document'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // File selector
          Obx(() {
            final file = controller.selectedFile.value;
            return Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                border: Border.all(
                  color: file != null
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey.shade300,
                  width: file != null ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(12),
                color: file != null
                    ? Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.05)
                    : null,
              ),
              child: Column(
                children: [
                  if (file != null) ...[
                    Icon(
                      _getFileIcon(file.path),
                      size: 48,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      file.path.split('/').last,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatFileSize(file.lengthSync()),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton.icon(
                      onPressed: () => _pickFile(controller),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Change File'),
                    ),
                  ] else ...[
                    const Icon(
                      Icons.cloud_upload_outlined,
                      size: 48,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Select a file to upload',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'PDF, images, or documents',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: () => _pickFile(controller),
                      icon: const Icon(Icons.folder_open),
                      label: const Text('Browse Files'),
                    ),
                  ],
                ],
              ),
            );
          }),
          const SizedBox(height: 24),

          // Document Type
          Text(
            'Document Type',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Obx(
            () => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: DocumentType.values.map((type) {
                final isSelected = controller.documentType.value == type;
                return ChoiceChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        type.icon,
                        size: 16,
                        color: isSelected ? Colors.white : type.color,
                      ),
                      const SizedBox(width: 4),
                      Text(type.displayName),
                    ],
                  ),
                  selected: isSelected,
                  onSelected: (_) => controller.setDocumentType(type),
                  selectedColor: Theme.of(context).colorScheme.primary,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),

          // Property selector (if not preset)
          if (controller.propertyId == null)
            _PropertySelector(controller: controller),

          // Description
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Description (Optional)',
              hintText: 'Add a description for this document',
              alignLabelWithHint: true,
            ),
            maxLines: 3,
            onChanged: controller.setDescription,
          ),
          const SizedBox(height: 16),

          // Expiry Date
          Text(
            'Expiry Date (Optional)',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Obx(
            () => InkWell(
              onTap: () => _selectExpiryDate(context, controller),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.event, color: Colors.grey),
                    const SizedBox(width: 12),
                    Text(
                      controller.expiryDate.value != null
                          ? dateFormat.format(controller.expiryDate.value!)
                          : 'Select expiry date',
                      style: TextStyle(
                        color: controller.expiryDate.value != null
                            ? Colors.black
                            : Colors.grey,
                      ),
                    ),
                    const Spacer(),
                    if (controller.expiryDate.value != null)
                      IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        onPressed: () => controller.setExpiryDate(null),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Upload button
          Obx(
            () => AppButton(
              label: 'Upload Document',
              isLoading: controller.isUploading.value,
              onPressed: controller.canSubmit ? controller.upload : null,
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  IconData _getFileIcon(String path) {
    final ext = path.split('.').last.toLowerCase();
    switch (ext) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return Icons.image;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      default:
        return Icons.insert_drive_file;
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  Future<void> _pickFile(DocumentUploadController controller) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'doc', 'docx'],
    );

    if (result != null && result.files.single.path != null) {
      controller.setSelectedFile(File(result.files.single.path!));
    }
  }

  Future<void> _selectExpiryDate(
    BuildContext context,
    DocumentUploadController controller,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: controller.expiryDate.value ??
          DateTime.now().add(const Duration(days: 365)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
    );
    if (picked != null) {
      controller.setExpiryDate(picked);
    }
  }
}

class _PropertySelector extends StatefulWidget {
  const _PropertySelector({required this.controller});

  final DocumentUploadController controller;

  @override
  State<_PropertySelector> createState() => _PropertySelectorState();
}

class _PropertySelectorState extends State<_PropertySelector> {
  List<_PropertyOption> _properties = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    unawaited(_loadProperties());
  }

  Future<void> _loadProperties() async {
    try {
      final repository = Get.find<PropertiesRepository>();
      final page =
          await repository.getProperties(page: 1, limit: 100, query: '');
      setState(() {
        _properties = page.items
            .map((p) => _PropertyOption(id: p.id, title: p.title))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Property (Optional)',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Obx(
          () => DropdownButtonFormField<int>(
            initialValue: widget.controller.selectedPropertyId.value,
            decoration: const InputDecoration(
              hintText: 'Select a property',
              prefixIcon: Icon(Icons.apartment),
            ),
            items: [
              const DropdownMenuItem(
                child: Text('No property'),
              ),
              ..._properties.map((prop) {
                return DropdownMenuItem(
                  value: prop.id,
                  child: Text(prop.title),
                );
              }),
            ],
            onChanged: (value) => widget.controller.setPropertyId(value),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _PropertyOption {
  const _PropertyOption({required this.id, required this.title});

  final int id;
  final String title;
}
