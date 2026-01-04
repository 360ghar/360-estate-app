import 'dart:async';

import 'package:estate_app/core/presentation/errors/failure_localization.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/state/view_state.dart';
import 'package:estate_app/core/presentation/widgets/app_button.dart';
import 'package:estate_app/core/presentation/widgets/app_card.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_loader.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/features/applications/domain/entities/application.dart';
import 'package:estate_app/features/applications/presentation/controllers/application_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ApplicationDetailPage extends StatelessWidget {
  const ApplicationDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ApplicationDetailView();
  }
}

class _ApplicationDetailView extends StatelessWidget {
  const _ApplicationDetailView();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ApplicationDetailController>();
    final dateFormat = DateFormat('MMM d, yyyy');
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹');

    return Obx(() {
      final state = controller.state.value;

      return AppScaffold(
        appBar: AppBar(
          title: const Text('Application Details'),
        ),
        body: Builder(
          builder: (_) {
            switch (state.status) {
              case ViewStatus.idle:
              case ViewStatus.loading:
                return const Center(child: AppLoader());

              case ViewStatus.empty:
              case ViewStatus.error:
                return AppErrorView(
                  title: context.l10n.errorSomethingWentWrong,
                  message: state.failure?.localizedMessage(context.l10n) ??
                      'Failed to load application',
                  retryLabel: context.l10n.commonRetry,
                  onRetry: () => unawaited(controller.loadApplication()),
                );

              case ViewStatus.success:
                final application = state.data!;
                return _buildContent(
                  context,
                  application,
                  controller,
                  dateFormat,
                  currencyFormat,
                );
            }
          },
        ),
      );
    });
  }

  Widget _buildContent(
    BuildContext context,
    Application application,
    ApplicationDetailController controller,
    DateFormat dateFormat,
    NumberFormat currencyFormat,
  ) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Header Card
        _HeaderCard(application: application),
        const SizedBox(height: 16),

        // Action Buttons
        if (application.canReview || application.canDecide)
          _ActionCard(application: application, controller: controller),

        // Property Info
        if (application.propertyTitle != null) ...[
          const SizedBox(height: 16),
          _InfoCard(
            title: 'Property',
            children: [
              _InfoRow(
                icon: Icons.apartment,
                label: 'Property',
                value: application.propertyTitle!,
              ),
              if (application.propertyAddress != null)
                _InfoRow(
                  icon: Icons.location_on,
                  label: 'Address',
                  value: application.propertyAddress!,
                ),
            ],
          ),
        ],

        // Applicant Info
        const SizedBox(height: 16),
        _InfoCard(
          title: 'Applicant Information',
          children: [
            _InfoRow(
              icon: Icons.person,
              label: 'Name',
              value: application.applicantName,
            ),
            _InfoRow(
              icon: Icons.email,
              label: 'Email',
              value: application.applicantEmail,
            ),
            _InfoRow(
              icon: Icons.phone,
              label: 'Phone',
              value: application.applicantPhone,
            ),
            if (application.currentAddress != null)
              _InfoRow(
                icon: Icons.home,
                label: 'Current Address',
                value: application.currentAddress!,
              ),
          ],
        ),

        // Move-in Details
        const SizedBox(height: 16),
        _InfoCard(
          title: 'Move-in Details',
          children: [
            if (application.desiredMoveInDate != null)
              _InfoRow(
                icon: Icons.calendar_today,
                label: 'Desired Date',
                value: dateFormat.format(application.desiredMoveInDate!),
              ),
            if (application.numberOfOccupants != null)
              _InfoRow(
                icon: Icons.people,
                label: 'Occupants',
                value: '${application.numberOfOccupants}',
              ),
            _InfoRow(
              icon: Icons.pets,
              label: 'Pets',
              value: application.hasPets ? 'Yes' : 'No',
            ),
            if (application.hasPets && application.petDetails != null)
              _InfoRow(
                icon: Icons.info,
                label: 'Pet Details',
                value: application.petDetails!,
              ),
            if (application.reasonForMoving != null)
              _InfoRow(
                icon: Icons.help_outline,
                label: 'Reason',
                value: application.reasonForMoving!,
              ),
          ],
        ),

        // Employment Info
        if (application.employmentStatus != null ||
            application.monthlyIncome != null) ...[
          const SizedBox(height: 16),
          _InfoCard(
            title: 'Employment & Income',
            children: [
              if (application.employmentStatus != null)
                _InfoRow(
                  icon: Icons.work,
                  label: 'Status',
                  value: application.employmentStatus!,
                ),
              if (application.employerName != null)
                _InfoRow(
                  icon: Icons.business,
                  label: 'Employer',
                  value: application.employerName!,
                ),
              if (application.monthlyIncome != null)
                _InfoRow(
                  icon: Icons.attach_money,
                  label: 'Monthly Income',
                  value: currencyFormat.format(application.monthlyIncome),
                ),
            ],
          ),
        ],

        // Emergency Contact
        if (application.emergencyContactName != null) ...[
          const SizedBox(height: 16),
          _InfoCard(
            title: 'Emergency Contact',
            children: [
              _InfoRow(
                icon: Icons.person,
                label: 'Name',
                value: application.emergencyContactName!,
              ),
              if (application.emergencyContactPhone != null)
                _InfoRow(
                  icon: Icons.phone,
                  label: 'Phone',
                  value: application.emergencyContactPhone!,
                ),
            ],
          ),
        ],

        // References
        if (application.references.isNotEmpty) ...[
          const SizedBox(height: 16),
          _ReferencesCard(references: application.references),
        ],

        // Decision Info
        if (application.isDecided && application.decisionNotes != null) ...[
          const SizedBox(height: 16),
          _InfoCard(
            title: 'Decision',
            children: [
              _InfoRow(
                icon: application.isApproved
                    ? Icons.check_circle
                    : Icons.cancel,
                label: 'Status',
                value: application.status.displayName,
              ),
              if (application.decidedAt != null)
                _InfoRow(
                  icon: Icons.calendar_today,
                  label: 'Date',
                  value: dateFormat.format(application.decidedAt!),
                ),
              if (application.decisionNotes != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    application.decisionNotes!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
            ],
          ),
        ],

        const SizedBox(height: 80),
      ],
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.application});

  final Application application;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: application.status.color.withOpacity(0.1),
            child: Text(
              application.applicantName.isNotEmpty
                  ? application.applicantName[0].toUpperCase()
                  : '?',
              style: TextStyle(
                fontSize: 24,
                color: application.status.color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  application.applicantName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: application.status.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        application.status.icon,
                        size: 14,
                        color: application.status.color,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        application.status.displayName,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: application.status.color,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.application,
    required this.controller,
  });

  final Application application;
  final ApplicationDetailController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() => AppCard(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (application.canReview)
                  AppButton(
                    label: 'Start Review',
                    leading: const Icon(Icons.rate_review, size: 18),
                    isLoading: controller.isActionLoading.value,
                    onPressed: () => unawaited(controller.startReview()),
                  ),
                if (application.canDecide) ...[
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          label: 'Approve',
                          leading: const Icon(Icons.check, size: 18),
                          isLoading: controller.isActionLoading.value,
                          onPressed: () =>
                              _showDecisionDialog(context, isApprove: true),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: AppButton(
                          label: 'Reject',
                          variant: AppButtonVariant.destructive,
                          leading: const Icon(Icons.close, size: 18),
                          isLoading: controller.isActionLoading.value,
                          onPressed: () =>
                              _showDecisionDialog(context, isApprove: false),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
      );
  }

  void _showDecisionDialog(BuildContext context, {required bool isApprove}) {
    final notesController = TextEditingController();

    unawaited(showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isApprove ? 'Approve Application' : 'Reject Application'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isApprove
                  ? 'Are you sure you want to approve this application?'
                  : 'Are you sure you want to reject this application?',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: notesController,
              decoration: const InputDecoration(
                labelText: 'Notes (Optional)',
                hintText: 'Add any notes about your decision',
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (isApprove) {
                unawaited(controller.approve(
                  notes: notesController.text.isEmpty
                      ? null
                      : notesController.text,
                ));
              } else {
                unawaited(controller.reject(
                  notes: notesController.text.isEmpty
                      ? null
                      : notesController.text,
                ));
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: isApprove ? Colors.green : Colors.red,
            ),
            child: Text(isApprove ? 'Approve' : 'Reject'),
          ),
        ],
      ),
    ));
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Theme.of(context).colorScheme.onSurfaceVariant),
          const SizedBox(width: 8),
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReferencesCard extends StatelessWidget {
  const _ReferencesCard({required this.references});

  final List<ApplicationReference> references;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'References',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          ...references.map((ref) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ref.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      ref.relationship,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.phone,
                            size: 14,
                            color: Theme.of(context).colorScheme.primary,),
                        const SizedBox(width: 4),
                        Text(
                          ref.phone,
                          style: TextStyle(
                            fontSize: 13,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),),
        ],
      ),
    );
  }
}
