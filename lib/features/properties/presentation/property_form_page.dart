import 'dart:async';

import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/errors/user_facing_message.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_error_view.dart';
import 'package:estate_app/core/presentation/widgets/app_loading_shimmer.dart';
import 'package:estate_app/core/presentation/widgets/app_section_card.dart';
import 'package:estate_app/core/presentation/widgets/feedback.dart';
import 'package:estate_app/core/presentation/widgets/motion.dart';
import 'package:estate_app/core/providers.dart';
import 'package:estate_app/features/properties/presentation/property_wizard_data.dart';
import 'package:estate_app/features/properties/presentation/widgets/wizard_step_bar.dart';
import 'package:estate_app/features/properties/presentation/widgets/wizard_step_details.dart';
import 'package:estate_app/features/properties/presentation/widgets/wizard_step_media.dart';
import 'package:estate_app/features/properties/presentation/widgets/wizard_step_terms.dart';
import 'package:estate_app/features/properties/properties_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

/// Creates or edits a property in five steps: basics, location,
/// specifications, rent and photos. A step shows its problems under the
/// fields and does not move on until they are fixed.
class PropertyFormPage extends ConsumerStatefulWidget {
  const PropertyFormPage({super.key, this.propertyId});

  final String? propertyId;

  @override
  ConsumerState<PropertyFormPage> createState() => _PropertyFormPageState();
}

class _PropertyFormPageState extends ConsumerState<PropertyFormPage> {
  static const int _totalSteps = 5;

  int _step = 0;
  PropertyWizardData? _data;
  bool _isSaving = false;
  bool _hasUnsavedChanges = false;
  int? _createdPropertyId;

  /// The problems shown under the fields of this step. Empty until the user
  /// tries to move on; then it follows every edit.
  Set<WizardIssue> _issues = {};
  bool _showIssues = false;

  /// Pictures picked on this screen, by their `file:` URI.
  final Map<String, XFile> _pendingFiles = {};

  /// URL of each picture that is already uploaded, by its `file:` URI. A save
  /// that failed after the upload does not upload the picture a second time.
  final Map<String, String> _uploadedByKey = {};
  final _imagePicker = ImagePicker();

  bool get _isEdit => widget.propertyId != null;

  @override
  void initState() {
    super.initState();
    if (!_isEdit) _data = PropertyWizardData();
  }

  /// The steps edit the data in place and call this.
  void _onDataChanged() {
    setState(() {
      _hasUnsavedChanges = true;
      if (_showIssues) _issues = _data!.issues(_step + 1).toSet();
    });
  }

  Future<void> _pickMedia({
    required int limit,
    required List<String> current,
    required void Function(String) add,
  }) async {
    if (current.length >= limit) {
      context.showSnack(context.l10n.propertyMediaLimit(limit));
      return;
    }
    final picked = await _imagePicker.pickMultiImage(imageQuality: 85);
    if (picked.isEmpty || !mounted) return;
    setState(() {
      _hasUnsavedChanges = true;
      for (final image in picked.take(limit - current.length)) {
        // A picked file always has a path on mobile. Web has none, so a unique
        // name stands in as the key.
        final key = image.path.isNotEmpty
            ? Uri.file(image.path).toString()
            : 'file:///web/${image.name}-${_pendingFiles.length}';
        _pendingFiles[key] = image;
        add(key);
      }
    });
  }

  void _remove(List<String> list, int index) => setState(() {
    _hasUnsavedChanges = true;
    _pendingFiles.remove(list.removeAt(index));
  });

  /// Shows the step's problems, or moves on (or saves on the last step).
  void _advance() {
    final issues = _data!.issues(_step + 1).toSet();
    if (issues.isNotEmpty) {
      setState(() {
        _showIssues = true;
        _issues = issues;
      });
      return;
    }
    if (_step == _totalSteps - 1) {
      unawaited(_submit());
      return;
    }
    setState(() {
      _step++;
      _showIssues = false;
      _issues = {};
    });
  }

  void _back() => setState(() {
    _step--;
    _showIssues = false;
    _issues = {};
  });

  /// Uploads the local files of [urls] and returns the URL list in order.
  /// Pictures that fail stay local so a second save retries them.
  Future<({List<String> urls, int failed})> _uploadPending(
    List<String> urls,
  ) async {
    final uploadService = ref.read(fileUploadServiceProvider);
    final result = <String>[];
    var failed = 0;
    for (final url in urls) {
      if (!PropertyWizardData.isLocalFile(url)) {
        result.add(url);
        continue;
      }
      final known = _uploadedByKey[url];
      if (known != null) {
        result.add(known);
        continue;
      }
      final file = _pendingFiles[url];
      if (file == null) {
        failed++;
        continue;
      }
      try {
        final uploaded = await uploadService.uploadPublicImage(file: file);
        _uploadedByKey[url] = uploaded.publicUrl;
        result.add(uploaded.publicUrl);
      } catch (_) {
        failed++;
      }
    }
    return (urls: result, failed: failed);
  }

  Future<void> _submit() async {
    final data = _data!;
    final l10n = context.l10n;
    setState(() => _isSaving = true);
    try {
      final repository = ref.read(propertiesRepositoryProvider);
      final currentId = _savedId;
      final isCreating = currentId == null;

      if (isCreating) {
        final property = await repository.create(data.toCreateBody());
        _createdPropertyId = property.id;
        data.markSaved();
      } else {
        final body = data.toPatchBody();
        if (body.isNotEmpty) {
          await repository.update(currentId, body);
          data.markFieldsSaved();
        }
      }

      // Upload the new pictures, then send the lists of URLs. A removed
      // picture must not leave its uploaded URL for a later pick of the same
      // file name.
      _uploadedByKey.removeWhere(
        (key, _) =>
            !data.images.contains(key) && !data.floorPlans.contains(key),
      );
      var failedUploads = 0;
      final propertyId = _savedId;
      if (propertyId != null) {
        final photos = await _uploadPending(data.images);
        final plans = await _uploadPending(data.floorPlans);
        failedUploads = photos.failed + plans.failed;
        final media = data.mediaPatch(
          photoUrls: photos.urls,
          floorPlanUrls: plans.urls,
        );
        if (media.isNotEmpty) {
          try {
            await repository.update(propertyId, media);
            data
              ..images = [
                ...photos.urls,
                ...data.images.where(PropertyWizardData.isLocalFile),
              ]
              ..floorPlans = [
                ...plans.urls,
                ...data.floorPlans.where(PropertyWizardData.isLocalFile),
              ]
              ..markSaved(
                savedImages: photos.urls,
                savedFloorPlans: plans.urls,
              );
          } catch (_) {
            failedUploads++;
          }
        }
      }

      ref
        ..invalidate(propertiesListProvider)
        ..invalidate(propertyTitlesProvider)
        ..invalidate(propertiesPagedProvider);
      if (_isEdit) ref.invalidate(propertyDetailProvider(widget.propertyId!));
      if (!mounted) return;

      if (failedUploads > 0) {
        // The property is saved. Stay here so a second save retries the
        // pictures that are still local.
        _hasUnsavedChanges = true;
        context.showSnack(l10n.propertyUploadsFailed(failedUploads));
      } else {
        _hasUnsavedChanges = false;
        context.showSnack(
          isCreating ? l10n.propertyCreated : l10n.propertyUpdated,
        );
        context.go('/properties');
      }
    } catch (error) {
      if (mounted) {
        context.showSnack(l10n.propertySaveFailed(userFacingMessage(error)));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  String? get _savedId {
    if (_createdPropertyId != null) return '$_createdPropertyId';
    final raw = widget.propertyId?.trim();
    return raw == null || raw.isEmpty ? null : raw;
  }

  Future<void> _confirmLeave() async {
    final l10n = context.l10n;
    final discard = await context.confirm(
      title: l10n.propertyDiscardTitle,
      message: l10n.propertyDiscardBody,
      confirmLabel: l10n.propertyDiscard,
      destructive: true,
    );
    if (!discard || !mounted) return;
    _hasUnsavedChanges = false;
    context.go('/properties');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    // Editing starts from the saved property, once it has loaded.
    if (_isEdit && _data == null) {
      final detail = ref.watch(propertyDetailProvider(widget.propertyId!));
      final loaded = detail.valueOrNull;
      if (loaded != null) {
        _data = PropertyWizardData.fromProperty(loaded.property);
      } else {
        return Scaffold(
          appBar: AppBar(title: Text(l10n.propertyEdit)),
          body: detail.hasError
              ? AppErrorView(
                  title: l10n.commonLoadFailedTitle,
                  message: userFacingMessage(detail.error!),
                  onRetry: () => ref.invalidate(
                    propertyDetailProvider(widget.propertyId!),
                  ),
                )
              : const AppLoadingShimmer(itemCount: 4),
        );
      }
    }

    final titles = [
      l10n.propertyStepBasics,
      l10n.propertyStepLocation,
      l10n.propertySpecs,
      l10n.propertyTabRent,
      l10n.propertyStepMedia,
    ];

    return PopScope(
      canPop: !_hasUnsavedChanges,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) unawaited(_confirmLeave());
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isEdit ? l10n.propertyEdit : l10n.propertyNew),
        ),
        body: Column(
          children: [
            WizardStepBar(titles: titles, current: _step),
            Expanded(
              child: SingleChildScrollView(
                key: PageStorageKey(_step),
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.sm,
                  AppSpacing.lg,
                  AppSpacing.xl,
                ),
                child: RiseIn(
                  key: ValueKey(_step),
                  child: AppSectionCard(
                    title: titles[_step],
                    child: _stepBody(),
                  ),
                ),
              ),
            ),
            _ActionBar(
              isFirst: _step == 0,
              isSaving: _isSaving,
              nextLabel: _step < _totalSteps - 1
                  ? l10n.propertyNext
                  : (_isEdit ? l10n.propertySaveChanges : l10n.propertyCreate),
              onBack: _back,
              onNext: _advance,
            ),
          ],
        ),
      ),
    );
  }

  Widget _stepBody() {
    final data = _data!;
    return switch (_step) {
      0 => WizardBasicsStep(
        data: data,
        onChanged: _onDataChanged,
        issues: _issues,
      ),
      1 => WizardLocationStep(
        data: data,
        onChanged: _onDataChanged,
        issues: _issues,
      ),
      2 => WizardSpecsStep(data: data, onChanged: _onDataChanged),
      3 => WizardRentStep(
        data: data,
        onChanged: _onDataChanged,
        issues: _issues,
      ),
      _ => WizardMediaStep(
        data: data,
        isUploading: _isSaving,
        onAddImages: () => _pickMedia(
          limit: WizardMediaStep.maxImages,
          current: data.images,
          add: data.images.add,
        ),
        onAddFloorPlans: () => _pickMedia(
          limit: WizardMediaStep.maxFloorPlans,
          current: data.floorPlans,
          add: data.floorPlans.add,
        ),
        onRemoveImage: (i) => _remove(data.images, i),
        onRemoveFloorPlan: (i) => _remove(data.floorPlans, i),
      ),
    };
  }
}

/// Back and Next at the foot of the screen, above the keyboard.
class _ActionBar extends StatelessWidget {
  const _ActionBar({
    required this.isFirst,
    required this.isSaving,
    required this.nextLabel,
    required this.onBack,
    required this.onNext,
  });

  final bool isFirst;
  final bool isSaving;
  final String nextLabel;
  final VoidCallback onBack;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) => Material(
    color: context.colors.surfaceContainerLow,
    child: SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.md,
        ),
        child: Row(
          children: [
            if (!isFirst) ...[
              TextButton.icon(
                onPressed: isSaving ? null : onBack,
                icon: const Icon(Icons.arrow_back_rounded),
                label: Text(context.l10n.commonBack),
              ),
              const SizedBox(width: AppSpacing.md),
            ],
            Expanded(
              child: FilledButton(
                onPressed: isSaving ? null : onNext,
                child: isSaving
                    ? SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: context.colors.onSurface,
                          semanticsLabel: context.l10n.commonLoading,
                        ),
                      )
                    : Text(nextLabel),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
