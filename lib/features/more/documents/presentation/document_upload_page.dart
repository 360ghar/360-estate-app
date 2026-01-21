import 'dart:io';

import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/features/more/documents/documents_providers.dart';
import 'package:file_picker/file_picker.dart';
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
  final _typeController = TextEditingController();
  File? _file;
  bool _isUploading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _typeController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null || result.files.isEmpty) return;
    final path = result.files.single.path;
    if (path == null) return;
    setState(() => _file = File(path));
  }

  Future<void> _upload() async {
    if (_file == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pick a file first.')),
      );
      return;
    }

    setState(() => _isUploading = true);
    try {
      await ref.read(documentsRepositoryProvider).upload(
            file: _file!,
            title: _titleController.text.trim(),
            type: _typeController.text.trim(),
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

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(title: const Text('Upload document')),
      scrollable: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Document title'),
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            controller: _typeController,
            decoration: const InputDecoration(labelText: 'Type'),
          ),
          const SizedBox(height: AppSpacing.md),
          OutlinedButton.icon(
            onPressed: _pickFile,
            icon: const Icon(Icons.attach_file),
            label: Text(_file == null ? 'Pick file' : 'Change file'),
          ),
          if (_file != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text('Selected: ${_file!.path.split(Platform.pathSeparator).last}'),
          ],
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _isUploading ? null : _upload,
              child: _isUploading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Upload document'),
            ),
          ),
        ],
      ),
    );
  }
}
