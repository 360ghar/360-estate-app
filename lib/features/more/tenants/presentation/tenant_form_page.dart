import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/app_section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tenant form page for creating/editing tenants
class TenantFormPage extends ConsumerStatefulWidget {
  const TenantFormPage({
    super.key,
    this.tenantId,
    this.propertyId,
  });

  final String? tenantId;
  final String? propertyId;

  @override
  ConsumerState<TenantFormPage> createState() => _TenantFormPageState();
}

class _TenantFormPageState extends ConsumerState<TenantFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _alternatePhoneController = TextEditingController();
  final _emergencyContactController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();
  final _permanentAddressController = TextEditingController();
  final _currentAddressController = TextEditingController();
  final _idNumberController = TextEditingController();
  final _occupationController = TextEditingController();
  final _workplaceController = TextEditingController();
  final _notesController = TextEditingController();

  String? _selectedIdType;
  String? _selectedMaritalStatus;
  String? _selectedGender;
  DateTime? _dateOfBirth;
  DateTime? _moveInDate;

  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _alternatePhoneController.dispose();
    _emergencyContactController.dispose();
    _emergencyPhoneController.dispose();
    _permanentAddressController.dispose();
    _currentAddressController.dispose();
    _idNumberController.dispose();
    _occupationController.dispose();
    _workplaceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate({required String field}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: field == 'dob'
          ? DateTime.now().subtract(const Duration(days: 18 * 365))
          : DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (field == 'dob') {
          _dateOfBirth = picked;
        } else {
          _moveInDate = picked;
        }
      });
    }
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSaving = true);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tenant management is not available yet.'),
      ),
    );
    setState(() => _isSaving = false);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.tenantId != null;

    return AppScaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Tenant' : 'Add New Tenant'),
      ),
      scrollable: true,
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Personal Information
              AppSectionCard(
                title: 'Personal Information',
                icon: Icons.person_outline,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name *',
                      hintText: 'e.g., Rahul Sharma',
                    ),
                    validator: (value) =>
                        value == null || value.trim().isEmpty ? 'Enter name' : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: _selectedGender,
                          decoration: const InputDecoration(labelText: 'Gender'),
                          items: const [
                            DropdownMenuItem(value: 'male', child: Text('Male')),
                            DropdownMenuItem(value: 'female', child: Text('Female')),
                            DropdownMenuItem(value: 'other', child: Text('Other')),
                          ],
                          onChanged: (value) => setState(() => _selectedGender = value),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: InkWell(
                          onTap: () => _selectDate(field: 'dob'),
                          borderRadius: BorderRadius.circular(12),
                          child: InputDecorator(
                            decoration: const InputDecoration(labelText: 'Date of Birth'),
                            child: Text(
                              _dateOfBirth == null
                                  ? 'Select date'
                                  : '${_dateOfBirth!.day}/${_dateOfBirth!.month}/${_dateOfBirth!.year}',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedMaritalStatus,
                    decoration: const InputDecoration(labelText: 'Marital Status'),
                    items: const [
                      DropdownMenuItem(value: 'single', child: Text('Single')),
                      DropdownMenuItem(value: 'married', child: Text('Married')),
                      DropdownMenuItem(value: 'divorced', child: Text('Divorced')),
                      DropdownMenuItem(value: 'widowed', child: Text('Widowed')),
                    ],
                    onChanged: (value) => setState(() => _selectedMaritalStatus = value),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // Contact Information
              AppSectionCard(
                title: 'Contact Information',
                icon: Icons.contact_phone_outlined,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _phoneController,
                          decoration: const InputDecoration(
                            labelText: 'Phone Number *',
                            hintText: '+91 98765 43210',
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) =>
                              value == null || value.trim().isEmpty ? 'Enter phone number' : null,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            hintText: 'rahul@example.com',
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _alternatePhoneController,
                    decoration: const InputDecoration(
                      labelText: 'Alternate Phone',
                      hintText: 'Secondary contact number',
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // Emergency Contact
              AppSectionCard(
                title: 'Emergency Contact',
                icon: Icons.emergency_outlined,
                iconColor: Colors.red,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _emergencyContactController,
                          decoration: const InputDecoration(
                            labelText: 'Emergency Contact Name',
                            hintText: 'Contact person name',
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: TextFormField(
                          controller: _emergencyPhoneController,
                          decoration: const InputDecoration(
                            labelText: 'Emergency Phone',
                            hintText: '+91 XXXXX XXXXX',
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // Identity Information
              AppSectionCard(
                title: 'Identity Information',
                icon: Icons.badge_outlined,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: _selectedIdType,
                          decoration: const InputDecoration(labelText: 'ID Type'),
                          items: const [
                            DropdownMenuItem(value: 'aadhaar', child: Text('Aadhaar Card')),
                            DropdownMenuItem(value: 'pan', child: Text('PAN Card')),
                            DropdownMenuItem(value: 'passport', child: Text('Passport')),
                            DropdownMenuItem(value: 'voter', child: Text('Voter ID')),
                            DropdownMenuItem(value: 'driving', child: Text('Driving License')),
                          ],
                          onChanged: (value) => setState(() => _selectedIdType = value),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: TextFormField(
                          controller: _idNumberController,
                          decoration: const InputDecoration(
                            labelText: 'ID Number',
                            hintText: 'Enter ID number',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // Address Information
              AppSectionCard(
                title: 'Address Information',
                icon: Icons.location_on_outlined,
                children: [
                  TextFormField(
                    controller: _permanentAddressController,
                    decoration: const InputDecoration(
                      labelText: 'Permanent Address',
                      hintText: 'Full permanent address',
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _currentAddressController,
                    decoration: const InputDecoration(
                      labelText: 'Current Address',
                      hintText: 'Current residential address',
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // Occupation & Work
              AppSectionCard(
                title: 'Occupation & Work',
                icon: Icons.work_outline,
                children: [
                  TextFormField(
                    controller: _occupationController,
                    decoration: const InputDecoration(
                      labelText: 'Occupation',
                      hintText: 'e.g., Software Engineer',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _workplaceController,
                    decoration: const InputDecoration(
                      labelText: 'Workplace/Company',
                      hintText: 'Company name',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // Property Assignment (for new tenants)
              if (!isEditing) ...[
                AppSectionCard(
                  title: 'Property Assignment',
                  icon: Icons.apartment_outlined,
                  children: [
                    InkWell(
                      onTap: () => _showPropertySelection(context),
                      borderRadius: BorderRadius.circular(12),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Assign Property',
                          hintText: 'Select property to assign',
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.apartment, size: 20),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Text(
                                widget.propertyId != null
                                    ? 'Property pre-selected'
                                    : 'No property selected',
                              ),
                            ),
                            const Icon(Icons.chevron_right, size: 20),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    InkWell(
                      onTap: () => _selectDate(field: 'moveIn'),
                      borderRadius: BorderRadius.circular(12),
                      child: InputDecorator(
                        decoration: const InputDecoration(labelText: 'Move-In Date'),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 20),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              _moveInDate == null
                                  ? 'Select move-in date'
                                  : '${_moveInDate!.day}/${_moveInDate!.month}/${_moveInDate!.year}',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
              ],

              // Additional Notes
              AppSectionCard(
                title: 'Additional Notes',
                icon: Icons.note_outlined,
                children: [
                  TextFormField(
                    controller: _notesController,
                    decoration: const InputDecoration(
                      labelText: 'Notes',
                      hintText: 'Any additional information',
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isSaving ? null : _submit,
                  child: _isSaving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(isEditing ? 'Update Tenant' : 'Add Tenant'),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }

  void _showPropertySelection(BuildContext context) {
    // TODO: Implement property selection dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Property selection coming soon')),
    );
  }
}
