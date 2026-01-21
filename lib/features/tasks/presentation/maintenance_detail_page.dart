import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/section_header.dart';
import 'package:estate_app/core/pagination/paged_list_controller.dart';
import 'package:estate_app/features/maintenance/domain/entities/maintenance_request.dart';
import 'package:estate_app/features/tasks/tasks_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MaintenanceDetailPage extends ConsumerStatefulWidget {
  const MaintenanceDetailPage({
    super.key,
    required this.requestId,
    this.initialRequest,
  });

  final String requestId;
  final MaintenanceRequest? initialRequest;

  @override
  ConsumerState<MaintenanceDetailPage> createState() =>
      _MaintenanceDetailPageState();
}

class _MaintenanceDetailPageState extends ConsumerState<MaintenanceDetailPage> {
  final _notesController = TextEditingController();
  late MaintenanceStatus _status;
  late MaintenancePriority _priority;
  bool _isSaving = false;
  bool _initialized = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _populate(MaintenanceRequest request) {
    if (_initialized) return;
    _status = request.status;
    _priority = request.priority;
    final notes = request.notes;
    _notesController.text =
        notes != null && notes.trim().isNotEmpty ? notes : request.description;
    _initialized = true;
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    try {
      final id = int.tryParse(widget.requestId);
      if (id == null) {
        throw Exception('Invalid request ID');
      }

      await ref.read(maintenanceRepositoryProvider).updateRequest(
            id,
            {
              'status': _status.apiValue,
              'priority': _priority.name,
              if (_notesController.text.trim().isNotEmpty)
                'notes': _notesController.text.trim(),
            },
          );
      ref.invalidate(maintenanceListProvider);
      ref.invalidate(maintenancePagedProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Request updated.')),
        );
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final initial = widget.initialRequest;
    final state = ref.watch(maintenancePagedProvider);

    return AppScaffold(
      appBar: AppBar(title: const Text('Request details')),
      scrollable: true,
      body: _buildBody(context, state, initial),
    );
  }

  Widget _buildBody(
    BuildContext context,
    PagedListState<MaintenanceRequest> state,
    MaintenanceRequest? initial,
  ) {
    // Handle invalid ID
    if (widget.requestId.isEmpty || widget.requestId == 'null') {
      return AppErrorView(
        title: 'Invalid Request',
        message: 'The request ID is not valid.',
        retryLabel: 'Go Back',
        onRetry: () => context.pop(),
      );
    }

    if (state.isInitialLoading && initial == null) {
      return const Center(child: CircularProgressIndicator());
    }

    MaintenanceRequest request;
    try {
      request = initial ??
          state.items.firstWhere(
            (item) => item.id.toString() == widget.requestId,
          );
    } catch (_) {
      return AppErrorView(
        title: 'Request not found',
        message: 'This maintenance request is unavailable.',
        retryLabel: 'Go Back',
        onRetry: () => context.pop(),
      );
    }

    _populate(request);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          request.title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(request.propertyTitle),
        const SizedBox(height: AppSpacing.lg),
        const SectionHeader(title: 'Update status'),
        const SizedBox(height: AppSpacing.md),
        DropdownButtonFormField<MaintenanceStatus>(
          value: _status,
          items: const [
            DropdownMenuItem(value: MaintenanceStatus.open, child: Text('Open')),
            DropdownMenuItem(
              value: MaintenanceStatus.inProgress,
              child: Text('In Progress'),
            ),
            DropdownMenuItem(
              value: MaintenanceStatus.completed,
              child: Text('Completed'),
            ),
            DropdownMenuItem(
              value: MaintenanceStatus.onHold,
              child: Text('On Hold'),
            ),
            DropdownMenuItem(
              value: MaintenanceStatus.cancelled,
              child: Text('Cancelled'),
            ),
          ],
          onChanged: (value) => setState(() => _status = value ?? _status),
          decoration: const InputDecoration(labelText: 'Status'),
        ),
        const SizedBox(height: AppSpacing.md),
        DropdownButtonFormField<MaintenancePriority>(
          value: _priority,
          items: const [
            DropdownMenuItem(value: MaintenancePriority.low, child: Text('Low')),
            DropdownMenuItem(
              value: MaintenancePriority.medium,
              child: Text('Medium'),
            ),
            DropdownMenuItem(
              value: MaintenancePriority.high,
              child: Text('High'),
            ),
            DropdownMenuItem(
              value: MaintenancePriority.urgent,
              child: Text('Urgent'),
            ),
          ],
          onChanged: (value) => setState(() => _priority = value ?? _priority),
          decoration: const InputDecoration(labelText: 'Priority'),
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: _notesController,
          maxLines: 3,
          decoration: const InputDecoration(labelText: 'Notes'),
        ),
        const SizedBox(height: AppSpacing.lg),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: _isSaving ? null : _save,
            child: _isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save updates'),
          ),
        ),
      ],
    );
  }
}
