import 'package:estate_app/core/auth/user_role.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/features/auth/presentation/auth_controller.dart';
import 'package:estate_app/features/auth/presentation/widgets/auth_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoleSelectionPage extends ConsumerStatefulWidget {
  const RoleSelectionPage({super.key});

  @override
  ConsumerState<RoleSelectionPage> createState() => _RoleSelectionPageState();
}

class _RoleSelectionPageState extends ConsumerState<RoleSelectionPage> {
  UserRole? _selectedRole;

  Future<void> _submit() async {
    final role = _selectedRole;
    if (role == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select a role to continue.')),
      );
      return;
    }
    await ref.read(authControllerProvider.notifier).setRole(role);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return AppScaffold(
      padding: EdgeInsets.zero,
      body: AuthPageLayout(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AuthTopBar(stepIndex: 2),
            const SizedBox(height: 20),
            Text('Select role', style: authTitleStyle(context)),
            const SizedBox(height: 8),
            Text(
              'Choose the role you are signing in as.',
              style: authSubtitleStyle(context),
            ),
            const SizedBox(height: 32),
            const AuthSectionLabel(text: 'CHOOSE ROLE'),
            const SizedBox(height: 8),
            _RoleCard(
              title: UserRole.owner.label,
              subtitle: 'I own properties',
              icon: Icons.apartment_rounded,
              selected: _selectedRole == UserRole.owner,
              onTap: () => setState(() => _selectedRole = UserRole.owner),
            ),
            const SizedBox(height: 12),
            _RoleCard(
              title: UserRole.manager.label,
              subtitle: 'I manage properties for others',
              icon: Icons.manage_accounts_rounded,
              selected: _selectedRole == UserRole.manager,
              onTap: () => setState(() => _selectedRole = UserRole.manager),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: authState.isBusy ? null : _submit,
                style: authPrimaryButtonStyle(),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            if (authState.errorMessage != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                authState.errorMessage!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? authAccent.withOpacity(0.08) : authFieldFill,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? authAccent : authFieldBorder,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: selected ? authAccent : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: selected ? authAccent : authFieldBorder,
                  width: 1,
                ),
              ),
              child: Icon(
                icon,
                size: 20,
                color: selected ? Colors.white : authAccent,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: authInk,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: authMuted,
                          fontSize: 13,
                        ),
                  ),
                ],
              ),
            ),
            if (selected)
              Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: authAccent,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 14,
                ),
              )
            else
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: authMuted.withOpacity(0.4),
                    width: 1.5,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
