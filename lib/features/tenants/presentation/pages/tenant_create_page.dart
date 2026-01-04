import 'package:estate_app/core/presentation/state/view_state.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/features/tenants/presentation/controllers/tenant_create_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TenantCreatePage extends GetView<TenantCreateController> {
  const TenantCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppScaffold(
      appBar: AppBar(
        title: const Text('Add Tenant'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Get.back<void>(),
        ),
      ),
      body: Column(
        children: [
          // Stepper indicator
          Obx(() => _StepIndicator(
                currentStep: controller.currentStep.value,
                totalSteps: TenantCreateController.totalSteps,
              )),
          // Form content
          Expanded(
            child: Obx(() => _buildStepContent(context)),
          ),
          // Navigation buttons
          Obx(() => _buildNavigationButtons(context, theme)),
        ],
      ),
    );
  }

  Widget _buildStepContent(BuildContext context) {
    switch (controller.currentStep.value) {
      case 0:
        return _PersonalInfoForm(controller: controller);
      case 1:
        return _EmergencyContactForm(controller: controller);
      case 2:
        return _IdVerificationForm(controller: controller);
      case 3:
        return _NotesForm(controller: controller);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildNavigationButtons(BuildContext context, ThemeData theme) {
    final isLoading = controller.state.value.status == ViewStatus.loading;
    final isFirstStep = controller.currentStep.value == 0;
    final isLastStep =
        controller.currentStep.value == TenantCreateController.totalSteps - 1;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            if (!isFirstStep)
              Expanded(
                child: OutlinedButton(
                  onPressed: isLoading ? null : controller.previousStep,
                  child: const Text('Back'),
                ),
              ),
            if (!isFirstStep) const SizedBox(width: 16),
            Expanded(
              flex: isFirstStep ? 1 : 1,
              child: FilledButton(
                onPressed: isLoading
                    ? null
                    : () {
                        if (!controller.validateCurrentStep()) {
                          Get.snackbar(
                            'Validation Error',
                            'Please fill in all required fields',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: theme.colorScheme.error,
                            colorText: theme.colorScheme.onError,
                          );
                          return;
                        }
                        if (isLastStep) {
                          controller.submit();
                        } else {
                          controller.nextStep();
                        }
                      },
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(isLastStep ? 'Create Tenant' : 'Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({
    required this.currentStep,
    required this.totalSteps,
  });

  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final stepLabels = ['Personal', 'Emergency', 'ID', 'Notes'];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outlineVariant,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: List.generate(totalSteps, (index) {
          final isActive = index == currentStep;
          final isCompleted = index < currentStep;

          return Expanded(
            child: Row(
              children: [
                if (index > 0)
                  Expanded(
                    child: Container(
                      height: 2,
                      color: isCompleted
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outlineVariant,
                    ),
                  ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isActive || isCompleted
                            ? theme.colorScheme.primary
                            : theme.colorScheme.surfaceContainerHighest,
                        border: Border.all(
                          color: isActive || isCompleted
                              ? theme.colorScheme.primary
                              : theme.colorScheme.outline,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: isCompleted
                            ? Icon(
                                Icons.check,
                                size: 16,
                                color: theme.colorScheme.onPrimary,
                              )
                            : Text(
                                '${index + 1}',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: isActive
                                      ? theme.colorScheme.onPrimary
                                      : theme.colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      stepLabels[index],
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: isActive || isCompleted
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurfaceVariant,
                        fontWeight:
                            isActive ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                if (index < totalSteps - 1)
                  Expanded(
                    child: Container(
                      height: 2,
                      color: isCompleted
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outlineVariant,
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _PersonalInfoForm extends StatelessWidget {
  const _PersonalInfoForm({required this.controller});

  final TenantCreateController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Personal Information',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Enter the tenant\'s basic information',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: controller.fullNameController,
            decoration: const InputDecoration(
              labelText: 'Full Name *',
              hintText: 'Enter full name',
              prefixIcon: Icon(Icons.person_outlined),
            ),
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: controller.emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              hintText: 'Enter email address',
              prefixIcon: Icon(Icons.email_outlined),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: controller.phoneController,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              hintText: 'Enter phone number',
              prefixIcon: Icon(Icons.phone_outlined),
            ),
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
    );
  }
}

class _EmergencyContactForm extends StatelessWidget {
  const _EmergencyContactForm({required this.controller});

  final TenantCreateController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Emergency Contact',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add emergency contact details (optional)',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: controller.emergencyContactController,
            decoration: const InputDecoration(
              labelText: 'Contact Name',
              hintText: 'Enter emergency contact name',
              prefixIcon: Icon(Icons.contact_emergency_outlined),
            ),
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: controller.emergencyPhoneController,
            decoration: const InputDecoration(
              labelText: 'Contact Phone',
              hintText: 'Enter emergency contact phone',
              prefixIcon: Icon(Icons.phone_outlined),
            ),
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
    );
  }
}

class _IdVerificationForm extends StatelessWidget {
  const _IdVerificationForm({required this.controller});

  final TenantCreateController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ID Verification',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add government ID details (optional)',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          Obx(() => DropdownButtonFormField<String>(
                value: controller.governmentIdType.value,
                decoration: const InputDecoration(
                  labelText: 'ID Type',
                  prefixIcon: Icon(Icons.badge_outlined),
                ),
                items: TenantCreateController.idTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  controller.governmentIdType.value = value;
                },
              )),
          const SizedBox(height: 16),
          TextFormField(
            controller: controller.governmentIdNumberController,
            decoration: const InputDecoration(
              labelText: 'ID Number',
              hintText: 'Enter ID number',
              prefixIcon: Icon(Icons.numbers_outlined),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotesForm extends StatelessWidget {
  const _NotesForm({required this.controller});

  final TenantCreateController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Additional Notes',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add any additional notes about this tenant (optional)',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: controller.notesController,
            decoration: const InputDecoration(
              labelText: 'Notes',
              hintText: 'Enter any additional notes...',
              alignLabelWithHint: true,
            ),
            maxLines: 5,
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 24),
          Card(
            color: theme.colorScheme.primaryContainer.withOpacity(0.3),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outlined,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Review all information before creating the tenant. You can edit tenant details later.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
