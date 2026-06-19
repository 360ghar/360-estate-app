import 'dart:io';

import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_durations.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_shadows.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/app_section_card.dart';
import 'package:estate_app/core/presentation/widgets/wizard_progress_indicator.dart';
import 'package:estate_app/core/providers.dart';
import 'package:estate_app/features/documents/domain/entities/document.dart';
import 'package:estate_app/features/properties/domain/repositories/properties_repository.dart';
import 'package:estate_app/features/properties/presentation/property_wizard_data.dart';
import 'package:estate_app/features/properties/presentation/property_wizard_steps.dart';
import 'package:estate_app/features/properties/properties_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

/// Multi-step wizard for creating/editing properties.
///
/// Features:
/// - 5-step wizard with enhanced progress indicator
/// - Per-step validation
/// - Image upload with progress
/// - AppSectionCard wrapping for each step
/// - Clean, focused UI for each step
/// - Back/Next navigation with animated transitions
class PropertyFormPage extends ConsumerStatefulWidget {
  const PropertyFormPage({super.key, this.propertyId});

  final String? propertyId;

  @override
  ConsumerState<PropertyFormPage> createState() => _PropertyFormPageState();
}

class _PropertyFormPageState extends ConsumerState<PropertyFormPage> {
  int _currentStep = 0;
  PropertyWizardData _data = PropertyWizardData();
  bool _initialized = false;
  bool _isSaving = false;
  bool _isUploading = false;
  bool _hasUnsavedChanges = false;
  int? _createdPropertyId;
  final List<File> _imageFiles = [];
  final List<File> _floorPlanFiles = [];
  final _imagePicker = ImagePicker();

  static const int _totalSteps = 5;

  /// Wizard step definitions.
  static const List<WizardStep> _wizardSteps = [
    WizardStep(label: 'Basic', subtitle: 'Details', icon: Icons.info_outline_rounded),
    WizardStep(label: 'Location', subtitle: 'Address', icon: Icons.location_on_outlined),
    WizardStep(label: 'Specs', subtitle: 'Amenities', icon: Icons.list_alt_outlined),
    WizardStep(label: 'Financial', subtitle: 'Legal', icon: Icons.account_balance_outlined),
    WizardStep(label: 'Media', subtitle: 'Photos', icon: Icons.photo_library_outlined),
  ];

  /// Step titles for the section card headers.
  static const List<String> _stepTitles = [
    'Basic Details',
    'Location & Address',
    'Specifications & Amenities',
    'Financial & Legal',
    'Photos & Media',
  ];

  /// Step icons for the section card headers.
  static const List<IconData> _stepIcons = [
    Icons.info_outline_rounded,
    Icons.location_on_outlined,
    Icons.list_alt_outlined,
    Icons.account_balance_outlined,
    Icons.photo_library_outlined,
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeIfNeeded();
  }

  void _initializeIfNeeded() {
    if (_initialized) return;

    final isEdit = widget.propertyId != null;
    if (isEdit) {
      final propertyAsync = ref.read(propertyDetailProvider(widget.propertyId!));
      propertyAsync.whenData((property) {
        if (!_initialized) {
          setState(() {
            _data = PropertyWizardData.fromProperty(property);
            _initialized = true;
          });
        }
      });
    } else {
      _initialized = true;
    }
  }

  void _onDataChanged(PropertyWizardStepData newData) {
    setState(() {
      _hasUnsavedChanges = true;
      _data = _data.copyWith(
        name: newData.name,
        type: newData.type,
        managementStatus: newData.managementStatus,
        notes: newData.notes,
        address: newData.address,
        city: newData.city,
        state: newData.state,
        pincode: newData.pincode,
        unitCount: newData.unitCount,
        floorAreaSqft: newData.floorAreaSqft,
        bedroomCount: newData.bedroomCount,
        bathroomCount: newData.bathroomCount,
        balconyCount: newData.balconyCount,
        yearBuilt: newData.yearBuilt,
        amenities: newData.amenities,
        monthlyRentInr: newData.monthlyRentInr,
        paymentDueDay: newData.paymentDueDay,
        marketValue: newData.marketValue,
        assignedManagerId: newData.assignedManagerId,
        propertyTaxId: newData.propertyTaxId,
        insurancePolicy: newData.insurancePolicy,
        hoaInfo: newData.hoaInfo,
        images: newData.images,
        floorPlans: newData.floorPlans,
      );
    });
  }

  Future<void> _pickImages() async {
    if (_data.images.length >= 20) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Maximum 20 images allowed')),
        );
      }
      return;
    }

    final images = await _imagePicker.pickMultiImage(imageQuality: 85);

    if (images.isEmpty) return;

    final remaining = 20 - _data.images.length;
    final selectedImages = images.take(remaining).toList();

    final propertyId = _currentPropertyIdForUpload();
    if (propertyId == null) {
      setState(() {
        for (final image in selectedImages) {
          final file = File(image.path);
          _data.images.add(file.uri.toString());
          _imageFiles.add(file);
        }
      });
      return;
    }

    setState(() => _isUploading = true);

    try {
      final uploadService = ref.read(fileUploadServiceProvider);

      for (final image in selectedImages) {
        final file = File(image.path);
        final result = await uploadService.uploadFile(
          file: file,
          type: DocumentType.other.apiValue,
          title: _data.name ?? 'Property image',
          propertyId: propertyId,
        );
        if (result.url != null && mounted) {
          setState(() {
            _data.images.add(result.url!);
          });
        }
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload images: ${_formatError(error)}'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  Future<void> _pickFloorPlans() async {
    if (_data.floorPlans.length >= 10) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Maximum 10 floor plans allowed')),
        );
      }
      return;
    }

    final images = await _imagePicker.pickMultiImage(imageQuality: 85);

    if (images.isEmpty) return;

    final remaining = 10 - _data.floorPlans.length;
    final selectedImages = images.take(remaining).toList();

    final propertyId = _currentPropertyIdForUpload();
    if (propertyId == null) {
      setState(() {
        for (final image in selectedImages) {
          final file = File(image.path);
          _data.floorPlans.add(file.uri.toString());
          _floorPlanFiles.add(file);
        }
      });
      return;
    }

    setState(() => _isUploading = true);

    try {
      final uploadService = ref.read(fileUploadServiceProvider);

      for (final image in selectedImages) {
        final file = File(image.path);
        final result = await uploadService.uploadFile(
          file: file,
          type: DocumentType.other.apiValue,
          title: _data.name ?? 'Floor plan',
          propertyId: propertyId,
        );
        if (result.url != null && mounted) {
          setState(() {
            _data.floorPlans.add(result.url!);
          });
        }
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload floor plans: ${_formatError(error)}'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  void _removeImage(int index) {
    setState(() {
      _hasUnsavedChanges = true;
      final removed = _data.images[index];
      _data.images.removeAt(index);
      if (_isLocalFileUrl(removed)) {
        _imageFiles.removeWhere((file) => file.uri.toString() == removed);
      }
    });
  }

  void _removeFloorPlan(int index) {
    setState(() {
      _hasUnsavedChanges = true;
      final removed = _data.floorPlans[index];
      _data.floorPlans.removeAt(index);
      if (_isLocalFileUrl(removed)) {
        _floorPlanFiles.removeWhere((file) => file.uri.toString() == removed);
      }
    });
  }

  void _nextStep() {
    final error = _data.validateStep(_currentStep + 1);
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
      return;
    }

    if (_currentStep < _totalSteps - 1) {
      setState(() => _currentStep++);
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  Future<void> _submit() async {
    final error = _data.validateStep(_currentStep + 1);
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
      return;
    }

    setState(() => _isSaving = true);

    final remoteImages = _filterRemoteUrls(_data.images);
    final remoteFloorPlans = _filterRemoteUrls(_data.floorPlans);
    final payload = _data
        .copyWith(
          images: remoteImages.isEmpty ? null : remoteImages,
          floorPlans: remoteFloorPlans.isEmpty ? null : remoteFloorPlans,
        )
        .toPayload();

    try {
      final repository = ref.read(propertiesRepositoryProvider);
      final currentId = _currentPropertyIdForSubmit();
      final isCreating = currentId == null;

      // Create or update property
      final property = isCreating
          ? await repository.create(payload)
          : await repository.update(currentId, payload);
      if (isCreating && property.id != null) {
        _createdPropertyId = property.id;
      }

      final propertyId = property.id;
      int failedUploads = 0;

      // Upload local images if any
      if (propertyId != null &&
          (_imageFiles.isNotEmpty || _floorPlanFiles.isNotEmpty)) {
        setState(() => _isUploading = true);
        final uploadService = ref.read(fileUploadServiceProvider);

        final uploadedImages = <String>[...remoteImages];
        final succeededImageFiles = <File>[];
        for (final file in _imageFiles) {
          try {
            final result = await uploadService.uploadFile(
              file: file,
              type: DocumentType.other.apiValue,
              title: _data.name ?? 'Property image',
              propertyId: propertyId,
            );
            if (result.url != null) {
              uploadedImages.add(result.url!);
              succeededImageFiles.add(file);
            } else {
              failedUploads++;
            }
          } catch (e) {
            failedUploads++;
          }
        }

        final uploadedFloorPlans = <String>[...remoteFloorPlans];
        final succeededFloorPlanFiles = <File>[];
        for (final file in _floorPlanFiles) {
          try {
            final result = await uploadService.uploadFile(
              file: file,
              type: DocumentType.other.apiValue,
              title: _data.name ?? 'Floor plan',
              propertyId: propertyId,
            );
            if (result.url != null) {
              uploadedFloorPlans.add(result.url!);
              succeededFloorPlanFiles.add(file);
            } else {
              failedUploads++;
            }
          } catch (e) {
            failedUploads++;
          }
        }

        // Update property with uploaded image URLs
        if (uploadedImages.isNotEmpty || uploadedFloorPlans.isNotEmpty) {
          try {
            await repository.update(
              propertyId.toString(),
              PropertyPayload(
                images: uploadedImages.isEmpty ? null : uploadedImages,
                floorPlans: uploadedFloorPlans.isEmpty ? null : uploadedFloorPlans,
              ),
            );
          } catch (e) {
            // Log error but don't fail the entire operation
            failedUploads++;
          }
        }

        // Only remove successfully-uploaded files. Keep failed files so the
        // user can retry them; otherwise the local image references are lost
        // with no way to recover.
        for (final file in succeededImageFiles) {
          _imageFiles.remove(file);
        }
        for (final file in succeededFloorPlanFiles) {
          _floorPlanFiles.remove(file);
        }
      }

      ref.invalidate(propertiesListProvider);
      if (widget.propertyId != null) {
        ref.invalidate(propertyDetailProvider(widget.propertyId!));
      }
      ref.invalidate(propertiesPagedProvider);

      if (failedUploads > 0) {
        // Some uploads failed. Do NOT navigate away - keep the user on the
        // form so they can retry uploading the remaining local files. The
        // property itself was saved successfully.
        _hasUnsavedChanges = true;
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Property saved, but $failedUploads file(s) failed to '
                'upload. Tap Save again to retry.',
              ),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 5),
            ),
          );
        }
      } else {
        _hasUnsavedChanges = false;
        if (mounted) {
          // Navigate first, then show success message on the next screen
          context.go('/properties');
          // Show success message after navigation (using a post-frame callback)
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final action = isCreating ? 'created' : 'updated';
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Property $action successfully'),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 3),
              ),
            );
          });
        }
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save property: ${_formatError(error)}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
          _isSaving = false;
        });
      }
    }
  }

  int? _currentPropertyIdForUpload() {
    if (_createdPropertyId != null) return _createdPropertyId;
    final raw = widget.propertyId;
    if (raw == null || raw.trim().isEmpty) return null;
    return int.tryParse(raw);
  }

  String? _currentPropertyIdForSubmit() {
    if (_createdPropertyId != null) return _createdPropertyId.toString();
    final raw = widget.propertyId;
    if (raw == null || raw.trim().isEmpty) return null;
    return raw;
  }

  List<String> _filterRemoteUrls(List<String> urls) {
    return urls.where((url) => !_isLocalFileUrl(url)).toList();
  }

  bool _isLocalFileUrl(String url) {
    final uri = Uri.tryParse(url);
    return uri != null && uri.scheme == 'file';
  }

  String _formatError(Object error) {
    if (error is ValidationFailure) {
      if (error.fields.isEmpty) return error.message;
      final details = error.fields.entries
          .map((entry) => '${entry.key}: ${entry.value}')
          .join(', ');
      return '${error.message} ($details)';
    }
    if (error is Failure) {
      return error.message;
    }
    return error.toString();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.propertyId != null;
    final stepData = PropertyWizardStepData(
      name: _data.name,
      type: _data.type,
      managementStatus: _data.managementStatus,
      notes: _data.notes,
      address: _data.address,
      city: _data.city,
      state: _data.state,
      pincode: _data.pincode,
      unitCount: _data.unitCount,
      floorAreaSqft: _data.floorAreaSqft,
      bedroomCount: _data.bedroomCount,
      bathroomCount: _data.bathroomCount,
      balconyCount: _data.balconyCount,
      yearBuilt: _data.yearBuilt,
      amenities: _data.amenities,
      monthlyRentInr: _data.monthlyRentInr,
      paymentDueDay: _data.paymentDueDay,
      marketValue: _data.marketValue,
      assignedManagerId: _data.assignedManagerId,
      propertyTaxId: _data.propertyTaxId,
      insurancePolicy: _data.insurancePolicy,
      hoaInfo: _data.hoaInfo,
      images: _data.images,
      floorPlans: _data.floorPlans,
    );

    return PopScope(
      canPop: !_hasUnsavedChanges,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final shouldDiscard = await _showDiscardDialog();
        if (shouldDiscard && mounted) {
          _hasUnsavedChanges = false;
          context.go('/properties');
        }
      },
      child: AppScaffold(
        appBar: AppBar(
          title: Text(isEdit ? 'Edit Property' : 'New Property'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(72),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              child: _EnhancedWizardIndicator(
                steps: _wizardSteps,
                currentStep: _currentStep,
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            // Step content wrapped in AppSectionCard
            Expanded(
              child: AnimatedSwitcher(
                duration: AppDurations.medium,
                switchInCurve: AppDurations.entranceCurve,
                switchOutCurve: AppDurations.exitCurve,
                child: SingleChildScrollView(
                  key: ValueKey(_currentStep),
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: AppSectionCard(
                    title: _stepTitles[_currentStep],
                    icon: _stepIcons[_currentStep],
                    child: _buildStepContent(stepData),
                  ),
                ),
              ),
            ),

            // Navigation buttons
            _buildNavigationButtons(context),
          ],
        ),
      ),
    );
  }

  Future<bool> _showDiscardDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard changes?'),
        content: const Text(
          'You have unsaved changes. Are you sure you want to leave?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Stay'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Widget _buildStepContent(PropertyWizardStepData stepData) {
    switch (_currentStep) {
      case 0:
        return PropertyWizardStep1(
          data: stepData,
          onChanged: _onDataChanged,
        );
      case 1:
        return PropertyWizardStep2(
          data: stepData,
          onChanged: _onDataChanged,
        );
      case 2:
        return PropertyWizardStep3(
          data: stepData,
          onChanged: _onDataChanged,
        );
      case 3:
        return PropertyWizardStep4(
          data: stepData,
          onChanged: _onDataChanged,
        );
      case 4:
        return PropertyWizardStep5(
          data: stepData,
          onChanged: _onDataChanged,
          onAddImages: _pickImages,
          onAddFloorPlans: _pickFloorPlans,
          onRemoveImage: _removeImage,
          onRemoveFloorPlan: _removeFloorPlan,
          isUploading: _isUploading,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildNavigationButtons(BuildContext context) {
    final isLastStep = _currentStep == _totalSteps - 1;
    final isFirstStep = _currentStep == 0;
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: scheme.surface,
        boxShadow: AppShadows.sectionDivider,
        border: Border(
          top: BorderSide(
            color: scheme.outlineVariant,
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Step counter
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Text(
                'Step ${_currentStep + 1} of $_totalSteps',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Row(
              children: [
                if (!isFirstStep)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isSaving ? null : _previousStep,
                      child: const Text('Back'),
                    ),
                  ),
                if (!isFirstStep) const SizedBox(width: AppSpacing.md),
                Expanded(
                  flex: 2,
                  child: FilledButton(
                    onPressed: _isSaving ? null : (isLastStep ? _submit : _nextStep),
                    child: _isSaving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(isLastStep ? (widget.propertyId != null ? 'Save Changes' : 'Create Property') : 'Next'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Enhanced wizard indicator with larger circles showing step number/check,
/// colored active step, and connecting lines.
class _EnhancedWizardIndicator extends StatelessWidget {
  const _EnhancedWizardIndicator({
    required this.steps,
    required this.currentStep,
  });

  final List<WizardStep> steps;
  final int currentStep;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        for (int i = 0; i < steps.length; i++) ...[
          if (i > 0)
            Expanded(
              child: Container(
                height: 2,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: i <= currentStep
                      ? scheme.primary
                      : (isDark ? AppColors.darkSurfaceVariant : AppColors.borderLight),
                  borderRadius: AppRadii.pill,
                ),
              ),
            ),
          _buildStepCircle(context, i, scheme, isDark),
        ],
      ],
    );
  }

  Widget _buildStepCircle(
    BuildContext context,
    int index,
    ColorScheme scheme,
    bool isDark,
  ) {
    final isCompleted = index < currentStep;
    final isActive = index == currentStep;

    Color bgColor;
    Color fgColor;

    if (isCompleted) {
      bgColor = scheme.primary;
      fgColor = Colors.white;
    } else if (isActive) {
      bgColor = scheme.primary;
      fgColor = Colors.white;
    } else {
      bgColor = isDark ? AppColors.darkSurfaceVariant : AppColors.surfaceSecondary;
      fgColor = isDark ? AppColors.darkTextSecondary : AppColors.textTertiary;
    }

    return AnimatedContainer(
      duration: AppDurations.medium,
      curve: AppDurations.defaultCurve,
      width: isActive ? 36 : 28,
      height: isActive ? 36 : 28,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        boxShadow: isActive ? AppShadows.cardHovered : null,
      ),
      child: Center(
        child: isCompleted
            ? Icon(Icons.check_rounded, size: 16, color: fgColor)
            : Text(
                '${index + 1}',
                style: TextStyle(
                  color: fgColor,
                  fontSize: isActive ? 14 : 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }
}
