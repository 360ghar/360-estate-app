import 'dart:async';
import 'dart:typed_data';

import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_avatar.dart';
import 'package:estate_app/core/presentation/widgets/app_section_card.dart';
import 'package:estate_app/core/presentation/widgets/feedback.dart';
import 'package:estate_app/features/auth/data/auth_repository.dart';
import 'package:estate_app/features/auth/models/user_profile.dart';
import 'package:estate_app/features/auth/presentation/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

/// Change your name, phone and photo. The email is shown, not edited here.
class ProfileEditPage extends ConsumerStatefulWidget {
  const ProfileEditPage({super.key});

  @override
  ConsumerState<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends ConsumerState<ProfileEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  XFile? _selectedImage;

  /// Preview bytes for [_selectedImage], read once on pick: reading inline
  /// would re-read the file and flicker the preview on every rebuild.
  Future<Uint8List>? _avatarBytes;
  String? _avatarUrl;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(authControllerProvider).user;
    if (profile != null) {
      _fullNameController.text = profile.fullName ?? profile.displayName;
      _emailController.text = profile.email ?? '';
      _phoneController.text = profile.phone ?? '';
      _avatarUrl = profile.avatarUrl;
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    Navigator.pop(context);
    final picked = await ImagePicker().pickImage(
      source: source,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    if (picked == null) return;
    setState(() {
      // Keep the XFile: a dart:io File breaks web builds.
      _selectedImage = picked;
      _avatarBytes = picked.readAsBytes();
    });
  }

  void _showPhotoOptions() {
    final l10n = context.l10n;
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        builder: (sheetContext) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: Text(l10n.profileTakePhoto),
                onTap: () => _pickImage(ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: Text(l10n.profileChoosePhoto),
                onTap: () => _pickImage(ImageSource.gallery),
              ),
              // The backend cannot delete a stored photo, so only a photo that
              // is picked but not saved yet can be removed.
              if (_selectedImage != null)
                ListTile(
                  iconColor: context.colors.error,
                  textColor: context.colors.error,
                  leading: const Icon(Icons.delete_outline_rounded),
                  title: Text(l10n.profileRemovePhoto),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    setState(() {
                      _selectedImage = null;
                      _avatarBytes = null;
                    });
                  },
                ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() => _isSaving = true);
    final controller = ref.read(authControllerProvider.notifier);
    try {
      // The photo has its own route; the profile save carries no photo and
      // no email.
      if (_selectedImage != null) {
        await controller.uploadProfilePhoto(_selectedImage!);
      }
      final phone = _phoneController.text.trim();
      await controller.updateProfile(
        UserProfileUpdate(
          fullName: _fullNameController.text.trim(),
          phone: phone.isEmpty ? null : phone,
        ),
      );
      if (!mounted) return;
      context.showSnack(context.l10n.profileSavedShort);
      context.pop();
    } catch (_) {
      if (mounted) context.showSnack(context.l10n.profileSaveFailed);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final busy = _isSaving || ref.watch(authControllerProvider).isBusy;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileEditAction)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.xxl,
          ),
          children: [
            Center(child: _photo()),
            Center(
              child: TextButton.icon(
                onPressed: busy ? null : _showPhotoOptions,
                icon: const Icon(Icons.photo_camera_outlined, size: 18),
                label: Text(l10n.profileChangePhoto),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppSectionCard(
              title: l10n.profileDetailsTitle,
              children: [
                const SizedBox(height: AppSpacing.sm),
                TextFormField(
                  controller: _fullNameController,
                  decoration: InputDecoration(labelText: l10n.profileName),
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.name],
                  validator: (value) => value == null || value.trim().isEmpty
                      ? l10n.validationNameRequired
                      : null,
                ),
                const SizedBox(height: AppSpacing.lg),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: l10n.profilePhone),
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.telephoneNumber],
                  onFieldSubmitted: (_) => busy ? null : _save(),
                  validator: (value) {
                    final v = value?.trim() ?? '';
                    return v.isNotEmpty && v.length < 10
                        ? l10n.validationPhoneTooShort
                        : null;
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                TextFormField(
                  controller: _emailController,
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: l10n.profileEmail,
                    helperText: l10n.profileEmailHelper,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            FilledButton(
              onPressed: busy ? null : _save,
              child: busy
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.commonSave),
            ),
          ],
        ),
      ),
    );
  }

  /// The photo to save: the one just picked, else the stored one, else
  /// initials.
  Widget _photo() {
    final bytes = _avatarBytes;
    if (bytes == null) {
      return AppAvatar(
        imageUrl: _avatarUrl,
        name: _fullNameController.text,
        size: AppAvatarSize.xl,
        // A photo picked during a save would be discarded when the page pops.
        onTap: _isSaving || ref.read(authControllerProvider).isBusy
            ? null
            : _showPhotoOptions,
      );
    }
    return Semantics(
      image: true,
      label: _fullNameController.text,
      child: ClipOval(
        child: SizedBox.square(
          dimension: 72,
          child: FutureBuilder<Uint8List>(
            future: bytes,
            builder: (context, snapshot) => snapshot.hasData
                ? Image.memory(snapshot.data!, fit: BoxFit.cover)
                : ColoredBox(color: context.colors.primaryContainer),
          ),
        ),
      ),
    );
  }
}
