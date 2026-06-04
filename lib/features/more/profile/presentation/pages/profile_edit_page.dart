import 'dart:async';
import 'dart:io';

import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_shadows.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/app_section_card.dart';
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
  final bool _isUploading = false;
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
    unawaited(showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                  borderRadius: AppRadii.pill,
                ),
              ),
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6).withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.camera_alt, color: Color(0xFF3B82F6), size: 20),
                ),
                title: Text(context.l10n?.takePhoto ?? 'Take Photo'),
                onTap: () => _pickImage(ImageSource.camera),
              ),
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B5CF6).withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.photo_library, color: Color(0xFF8B5CF6), size: 20),
                ),
                title: Text(context.l10n?.chooseFromGallery ?? 'Choose from Gallery'),
                onTap: () => _pickImage(ImageSource.gallery),
              ),
              if (_avatarUrl != null || _selectedImage != null)
                ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.danger.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.delete, color: AppColors.danger, size: 20),
                  ),
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
      ),
    ));
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
    final theme = Theme.of(context);

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
            const SizedBox(height: AppSpacing.md),

            // Photo section with camera overlay
            Center(
              child: GestureDetector(
                onTap: _showImageSourceDialog,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: AppShadows.md,
                  ),
                  child: Stack(
                    children: [
                      Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme.colorScheme.surface,
                            width: 4,
                          ),
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
                        bottom: 2,
                        right: 2,
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: theme.colorScheme.surface,
                              width: 3,
                            ),
                            boxShadow: AppShadows.sm,
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            size: 16,
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              context.l10n?.tapToChangePhoto ?? 'Tap to change photo',
              style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // Personal details section
            AppSectionCard(
              title: 'Personal Details',
              icon: Icons.person_outline,
              iconColor: const Color(0xFF3B82F6),
              children: [
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
              ],
            ),

            const SizedBox(height: AppSpacing.xl),

            // Save button
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
