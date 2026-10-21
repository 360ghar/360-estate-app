import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/errors/user_facing_message.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_card.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_loading_shimmer.dart';
import 'package:estate_app/core/presentation/widgets/app_section_card.dart';
import 'package:estate_app/core/presentation/widgets/app_status_badge.dart';
import 'package:estate_app/core/presentation/widgets/detail_line.dart';
import 'package:estate_app/core/presentation/widgets/feedback.dart';
import 'package:estate_app/core/presentation/widgets/submit_bar.dart';
import 'package:estate_app/core/utils/dates.dart';
import 'package:estate_app/core/utils/money.dart';
import 'package:estate_app/features/maintenance/domain/entities/maintenance_request.dart';
import 'package:estate_app/features/tasks/presentation/task_text.dart';
import 'package:estate_app/features/tasks/presentation/widgets/task_progress.dart';
import 'package:estate_app/features/tasks/tasks_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// One maintenance request: where it stands, its details, and the update
/// form (status, urgency, completion notes).
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
  MaintenanceRequestStatus? _status;
  MaintenanceUrgency? _urgency;
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
    _urgency = request.urgency;
    _notesController.text = request.completionNotes ?? '';
    _initialized = true;
  }

  Future<void> _save(MaintenanceRequest request) async {
    final l10n = context.l10n;
    // Only the keys the user changed go in the PATCH body.
    final notes = _notesController.text.trim();
    final update = MaintenanceUpdate(
      status: _status != request.status ? _status : null,
      urgency: _urgency != request.urgency ? _urgency : null,
      completionNotes:
          notes != (request.completionNotes ?? '').trim() && notes.isNotEmpty
          ? notes
          : null,
    );
    if (update.toJson().isEmpty) {
      context.showSnack(l10n.taskNothingToSave);
      return;
    }
    setState(() => _isSaving = true);
    try {
      await ref
          .read(maintenanceRepositoryProvider)
          .updateRequest(request.id, update);
      ref
        ..invalidate(maintenanceListProvider)
        ..invalidate(maintenanceListForPropertyProvider)
        ..invalidate(maintenanceRequestProvider(request.id))
        ..invalidate(maintenancePagedByStatusProvider);
      if (!mounted) return;
      context.showSnack(l10n.taskUpdated);
      context.go('/tasks');
    } catch (error) {
      if (mounted) context.showSnack(userFacingMessage(error));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final id = int.tryParse(widget.requestId);
    Widget notFound(String message) => AppErrorView(
      title: l10n.taskNotFoundTitle,
      message: message,
      retryLabel: l10n.taskGoBack,
      onRetry: () => context.go('/tasks'),
    );

    if (id == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.taskDetailTitle)),
        body: notFound(l10n.taskInvalidId),
      );
    }

    // The list passes the request it already has. The backend has no by-id
    // route, so a deep link finds the request in the list.
    var request = widget.initialRequest;
    Widget? body;
    if (request == null) {
      final lookup = ref.watch(maintenanceRequestProvider(id));
      if (lookup.isLoading) {
        body = const AppLoadingShimmer(itemCount: 3, itemHeight: 140);
      } else if (lookup.hasError) {
        body = AppErrorView(
          title: l10n.commonLoadFailedTitle,
          message: userFacingMessage(lookup.error!),
          onRetry: () => ref.invalidate(maintenanceRequestProvider(id)),
        );
      } else {
        request = lookup.valueOrNull;
        if (request == null) body = notFound(l10n.taskNotFoundBody);
      }
    }

    final loaded = request;
    if (loaded != null) _populate(loaded);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.taskDetailTitle)),
      body:
          body ??
          Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    ref
                      ..invalidate(maintenanceListProvider)
                      ..invalidate(maintenanceRequestProvider(id));
                  },
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    children: [
                      _Header(request: loaded!),
                      const SizedBox(height: AppSpacing.md),
                      _Details(request: loaded),
                      const SizedBox(height: AppSpacing.md),
                      _UpdateForm(
                        status: _status,
                        urgency: _urgency,
                        notes: _notesController,
                        onStatus: (s) => setState(() => _status = s),
                        onUrgency: (u) => setState(() => _urgency = u),
                      ),
                    ],
                  ),
                ),
              ),
              SubmitBar(
                label: l10n.taskSave,
                busy: _isSaving,
                onPressed: () => _save(loaded),
              ),
            ],
          ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.request});

  final MaintenanceRequest request;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final status = request.status;
    final urgency = request.urgency;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(request.title, style: context.text.headlineSmall),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            request.propertyName(l10n),
            style: context.text.bodyMedium?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.lg,
            runSpacing: AppSpacing.xs,
            children: [
              if (status != null)
                AppStatusBadge(
                  label: status.text(l10n),
                  type: status.statusType,
                ),
              if (urgency != null) TaskUrgencyLabel(urgency: urgency),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          TaskProgress(status: status),
        ],
      ),
    );
  }
}

class _Details extends ConsumerWidget {
  const _Details({required this.request});

  final MaintenanceRequest request;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final category = request.category;
    final agentId = request.assignedAgentId;
    // The backend gives the agent id only. The name is known for the agent
    // assigned to the signed-in user.
    final agent = ref.watch(assignedAgentProvider).valueOrNull;
    final description = request.description?.trim() ?? '';
    final rows = [
      if (category != null) (l10n.taskCategoryLabel, category.text(l10n)),
      if (request.tenantName != null)
        (l10n.taskTenantLabel, request.tenantName!),
      if (request.estimatedCost != null)
        (l10n.taskEstimatedCost, rupees(request.estimatedCost!)),
      if (request.scheduledFor != null)
        (l10n.taskScheduledFor, shortDate(context, request.scheduledFor!)),
      if (agentId != null)
        (
          l10n.taskAssignedAgent,
          agent != null && agent.id == agentId
              ? agent.name
              : l10n.taskAgentNumber('$agentId'),
        ),
      if (request.createdAt != null)
        (l10n.taskReported, shortDate(context, request.createdAt!)),
    ];
    return AppSectionCard(
      title: l10n.taskSectionInfo,
      children: [
        for (final (label, value) in rows)
          DetailLine(label: label, value: value),
        if (description.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(description, style: context.text.bodyMedium),
        ],
      ],
    );
  }
}

class _UpdateForm extends StatelessWidget {
  const _UpdateForm({
    required this.status,
    required this.urgency,
    required this.notes,
    required this.onStatus,
    required this.onUrgency,
  });

  final MaintenanceRequestStatus? status;
  final MaintenanceUrgency? urgency;
  final TextEditingController notes;
  final ValueChanged<MaintenanceRequestStatus> onStatus;
  final ValueChanged<MaintenanceUrgency> onUrgency;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final label = context.text.bodyMedium?.copyWith(
      color: context.colors.onSurfaceVariant,
    );
    return AppSectionCard(
      title: l10n.taskSectionUpdate,
      children: [
        Text(l10n.taskStatusLabel, style: label),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final s in MaintenanceRequestStatus.values)
              ChoiceChip(
                label: Text(s.text(l10n)),
                selected: status == s,
                onSelected: (_) => onStatus(s),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(l10n.taskUrgencyLabel, style: label),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final u in MaintenanceUrgency.values.reversed)
              ChoiceChip(
                avatar: Icon(u.glyph, size: 18),
                showCheckmark: false,
                label: Text(u.text(l10n)),
                selected: urgency == u,
                onSelected: (_) => onUrgency(u),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        TextField(
          controller: notes,
          minLines: 2,
          maxLines: 5,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            labelText: l10n.taskNotesLabel,
            hintText: l10n.taskNotesHint,
            alignLabelWithHint: true,
          ),
        ),
      ],
    );
  }
}
