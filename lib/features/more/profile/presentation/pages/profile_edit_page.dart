import 'dart:io';

import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/features/auth/data/auth_repository.dart';
import 'package:estate_app/features/auth/models/user_profile.dart';
import 'package:estate_app/features/auth/presentation/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

/// Profile edit page with photo upload capability
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

  File? _selectedImage;
  String? _avatarUrl;
  bool _isUploading = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _initFromProfile();
  }

  void _initFromProfile() {
    final authState = ref.read(authControllerProvider);
    final profile = authState.user;
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

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(context.l10n?.takePhoto ?? 'Take Photo'),
              onTap: () => _pickImage(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(context.l10n?.chooseFromGallery ?? 'Choose from Gallery'),
              onTap: () => _pickImage(ImageSource.gallery),
            ),
            if (_avatarUrl != null || _selectedImage != null)
              ListTile(
                leading: const Icon(Icons.delete, color: AppColors.danger),
                title: Text(
                  context.l10n?.removePhoto ?? 'Remove Photo',
                  style: const TextStyle(color: AppColors.danger),
                ),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedImage = null;
                    _avatarUrl = null;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      // First upload photo if selected
      String? finalAvatarUrl = _avatarUrl;
      if (_selectedImage != null) {
        final uploadedUrl = await ref
            .read(authControllerProvider.notifier)
            .uploadProfilePhoto(_selectedImage!);
        finalAvatarUrl = uploadedUrl;
      }

      // Then update profile
      await ref.read(authControllerProvider.notifier).updateProfile(
            UserProfileUpdate(
              fullName: _fullNameController.text.trim(),
              email: _emailController.text.trim().isEmpty
                  ? null
                  : _emailController.text.trim(),
              phone: _phoneController.text.trim().isEmpty
                  ? null
                  : _phoneController.text.trim(),
              avatarUrl: finalAvatarUrl,
            ),
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n?.profileSaved ?? 'Profile saved successfully'),
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n?.saveFailed ?? 'Failed to save profile'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isBusy = authState.isBusy || _isSaving || _isUploading;

    return AppScaffold(
      appBar: AppBar(
        title: Text(context.l10n?.editProfile ?? 'Edit Profile'),
        actions: [
          if (isBusy)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            TextButton(
              onPressed: _saveProfile,
              child: Text(context.l10n?.commonSave ?? 'Save'),
            ),
        ],
      ),
      scrollable: true,
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Avatar section
            Center(
              child: GestureDetector(
                onTap: _showImageSourceDialog,
                child: Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.primary,
                            AppColors.primaryLight,
                          ],
                        ),
                      ),
                      child: _buildAvatarContent(),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          size: 18,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              context.l10n?.tapToChangePhoto ?? 'Tap to change photo',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Form fields
            TextFormField(
              controller: _fullNameController,
              decoration: InputDecoration(
                labelText: context.l10n?.fullNameLabel ?? 'Full Name',
                prefixIcon: const Icon(Icons.person_outline),
              ),
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return context.l10n?.validationNameRequired ?? 'Name is required';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.md),

            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: context.l10n?.emailLabel ?? 'Email',
                prefixIcon: const Icon(Icons.email_outlined),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value != null &&
                    value.trim().isNotEmpty &&
                    !value.contains('@')) {
                  return context.l10n?.validationEmailInvalid ?? 'Invalid email';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.md),

            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: context.l10n?.phoneNumberLabel ?? 'Phone Number',
                prefixIcon: const Icon(Icons.phone_outlined),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value != null &&
                    value.trim().isNotEmpty &&
                    value.length < 10) {
                  return context.l10n?.validationPhoneTooShort ??
                      'Phone number is too short';
                }
                return null;
              },
            ),

            const SizedBox(height: AppSpacing.xl),

            // Save button (for larger tap target)
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: isBusy ? null : _saveProfile,
                child: Text(context.l10n?.commonSave ?? 'Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarContent() {
    if (_selectedImage != null) {
      return ClipOval(
        child: Image.file(
          _selectedImage!,
          fit: BoxFit.cover,
        ),
      );
    }

    if (_avatarUrl != null && _avatarUrl!.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          _avatarUrl!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildFallbackAvatar();
          },
        ),
      );
    }

    return _buildFallbackAvatar();
  }

  Widget _buildFallbackAvatar() {
    final initial = (_fullNameController.text.isNotEmpty
            ? _fullNameController.text[0]
            : '?')
        .toUpperCase();

    return Center(
      child: Text(
        initial,
        style: const TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}
