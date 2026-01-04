import 'package:estate_app/core/presentation/state/view_state.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/features/leases/presentation/controllers/lease_create_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class LeaseCreatePage extends GetView<LeaseCreateController> {
  const LeaseCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppScaffold(
      appBar: AppBar(
        title: const Text('Create Lease'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Get.back<void>(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoadingDropdowns.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Form(
          key: controller.formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildSectionHeader(theme, 'Property & Tenant'),
              const SizedBox(height: 12),
              _buildPropertyDropdown(theme),
              const SizedBox(height: 16),
              _buildTenantDropdown(theme),
              const SizedBox(height: 24),
              _buildSectionHeader(theme, 'Lease Duration'),
              const SizedBox(height: 12),
              _buildDatePickers(context, theme),
              const SizedBox(height: 24),
              _buildSectionHeader(theme, 'Financial Terms'),
              const SizedBox(height: 12),
              _buildFinancialFields(theme),
              const SizedBox(height: 24),
              _buildSectionHeader(theme, 'Late Fee Policy'),
              const SizedBox(height: 12),
              _buildLateFeeFields(theme),
              const SizedBox(height: 24),
              _buildSectionHeader(theme, 'Additional Details'),
              const SizedBox(height: 12),
              _buildAdditionalFields(theme),
              const SizedBox(height: 32),
              _buildSubmitButton(theme),
              const SizedBox(height: 16),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.primary,
      ),
    );
  }

  Widget _buildPropertyDropdown(ThemeData theme) {
    return Obx(() => DropdownButtonFormField<int>(
          value: controller.selectedProperty.value?.id,
          decoration: InputDecoration(
            labelText: 'Select Property *',
            prefixIcon: const Icon(Icons.apartment),
            filled: true,
            fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
          ),
          items: controller.properties.map((property) {
            return DropdownMenuItem(
              value: property.id,
              child: Text(
                property.displayName,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              controller.selectedProperty.value =
                  controller.properties.firstWhere((p) => p.id == value);
              // Auto-fill rent from property
              if (controller.monthlyRentController.text.isEmpty) {
                controller.monthlyRentController.text =
                    controller.selectedProperty.value!.monthlyRentInr.toString();
              }
            }
          },
        ));
  }

  Widget _buildTenantDropdown(ThemeData theme) {
    return Obx(() => DropdownButtonFormField<int>(
          value: controller.selectedTenant.value?.id,
          decoration: InputDecoration(
            labelText: 'Select Tenant *',
            prefixIcon: const Icon(Icons.person),
            filled: true,
            fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
          ),
          items: controller.tenants.map((tenant) {
            return DropdownMenuItem(
              value: tenant.id,
              child: Text(
                tenant.fullName,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              controller.selectedTenant.value =
                  controller.tenants.firstWhere((t) => t.id == value);
            }
          },
        ));
  }

  Widget _buildDatePickers(BuildContext context, ThemeData theme) {
    final dateFormat = DateFormat('dd MMM yyyy');

    return Row(
      children: [
        Expanded(
          child: Obx(() => InkWell(
                onTap: () => _selectDate(context, isStartDate: true),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Start Date *',
                    prefixIcon: const Icon(Icons.calendar_today),
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
                  ),
                  child: Text(
                    controller.startDate.value != null
                        ? dateFormat.format(controller.startDate.value!)
                        : 'Select date',
                    style: controller.startDate.value == null
                        ? theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          )
                        : null,
                  ),
                ),
              )),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Obx(() => InkWell(
                onTap: () => _selectDate(context, isStartDate: false),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'End Date *',
                    prefixIcon: const Icon(Icons.event),
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
                  ),
                  child: Text(
                    controller.endDate.value != null
                        ? dateFormat.format(controller.endDate.value!)
                        : 'Select date',
                    style: controller.endDate.value == null
                        ? theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          )
                        : null,
                  ),
                ),
              )),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context, {required bool isStartDate}) async {
    final initialDate = isStartDate
        ? (controller.startDate.value ?? DateTime.now())
        : (controller.endDate.value ?? 
            (controller.startDate.value?.add(const Duration(days: 365)) ?? 
             DateTime.now().add(const Duration(days: 365))));

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      if (isStartDate) {
        controller.startDate.value = picked;
        // Auto-set end date to 1 year later if not set
        if (controller.endDate.value == null) {
          controller.endDate.value = picked.add(const Duration(days: 365));
        }
      } else {
        controller.endDate.value = picked;
      }
    }
  }

  Widget _buildFinancialFields(ThemeData theme) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller.monthlyRentController,
                decoration: InputDecoration(
                  labelText: 'Monthly Rent *',
                  prefixIcon: const Icon(Icons.currency_rupee),
                  filled: true,
                  fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: controller.securityDepositController,
                decoration: InputDecoration(
                  labelText: 'Security Deposit',
                  prefixIcon: const Icon(Icons.account_balance_wallet),
                  filled: true,
                  fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Obx(() => DropdownButtonFormField<int>(
              value: controller.rentDueDay.value,
              decoration: InputDecoration(
                labelText: 'Rent Due Day of Month',
                prefixIcon: const Icon(Icons.today),
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
              ),
              items: List.generate(28, (i) => i + 1).map((day) {
                return DropdownMenuItem(
                  value: day,
                  child: Text('$day${_getDaySuffix(day)}'),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  controller.rentDueDay.value = value;
                }
              },
            )),
      ],
    );
  }

  String _getDaySuffix(int day) {
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  Widget _buildLateFeeFields(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: controller.lateFeeAmountController,
            decoration: InputDecoration(
              labelText: 'Late Fee Amount',
              prefixIcon: const Icon(Icons.money_off),
              filled: true,
              fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
            ),
            keyboardType: TextInputType.number,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TextFormField(
            controller: controller.lateFeeGraceDaysController,
            decoration: InputDecoration(
              labelText: 'Grace Days',
              prefixIcon: const Icon(Icons.timer),
              filled: true,
              fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
            ),
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalFields(ThemeData theme) {
    return Column(
      children: [
        TextFormField(
          controller: controller.renewalNotifyDaysController,
          decoration: InputDecoration(
            labelText: 'Renewal Reminder (days before)',
            prefixIcon: const Icon(Icons.notifications),
            filled: true,
            fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: controller.notesController,
          decoration: InputDecoration(
            labelText: 'Notes',
            prefixIcon: const Icon(Icons.notes),
            alignLabelWithHint: true,
            filled: true,
            fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
          ),
          maxLines: 3,
          textCapitalization: TextCapitalization.sentences,
        ),
      ],
    );
  }

  Widget _buildSubmitButton(ThemeData theme) {
    return Obx(() {
      final isLoading = controller.state.value.status == ViewStatus.loading;
      
      return FilledButton.icon(
        onPressed: isLoading ? null : controller.submit,
        icon: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.check),
        label: Text(isLoading ? 'Creating...' : 'Create Lease'),
        style: FilledButton.styleFrom(
          minimumSize: const Size(double.infinity, 56),
        ),
      );
    });
  }
}
