import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/network/owner_scope.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_card.dart';
import 'package:estate_app/core/presentation/widgets/with_text_controller.dart';
import 'package:estate_app/core/providers.dart';
import 'package:estate_app/features/auth/presentation/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Shows which owner an agent or admin acts for, and lets them change it.
///
/// An agent must name an owner: the backend refuses an agent's PM list or
/// create without `owner_id`. There is no owner directory to browse, so the
/// owner is picked by the owner's user id. The choice is kept per account.
/// An owner (role `user`) sees nothing here.
class OwnerScopeCard extends ConsumerWidget {
  const OwnerScopeCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(authControllerProvider.select((s) => s.user?.role));
    if (role != UserRole.agent && role != UserRole.admin) {
      return const SizedBox.shrink();
    }
    final scope = ref.watch(ownerScopeProvider);
    final l10n = context.l10n;
    final ownerId = scope.ownerId;

    final title = ownerId == null
        ? (scope.requiresOwner
              ? l10n.ownerScopeChooseTitle
              : l10n.ownerScopeAllTitle)
        : l10n.ownerScopeManaging(ownerId);
    final message = ownerId == null && scope.requiresOwner
        ? l10n.ownerScopeNeedOwnerBody
        : l10n.ownerScopeForOwnerBody;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: AppCard(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.sm,
          AppSpacing.md,
        ),
        child: Row(
          children: [
            ExcludeSemantics(
              child: Icon(
                Icons.badge_outlined,
                color: context.colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: context.text.titleMedium),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    message,
                    style: context.text.bodySmall?.copyWith(
                      color: context.colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            TextButton(
              onPressed: () => _pickOwner(context, ref, role!, scope),
              child: Text(
                ownerId == null ? l10n.ownerScopeChoose : l10n.ownerScopeChange,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickOwner(
    BuildContext context,
    WidgetRef ref,
    UserRole role,
    OwnerScope scope,
  ) async {
    final userId = ref.read(authControllerProvider).user?.id;
    if (userId == null) return;
    final formKey = GlobalKey<FormState>();
    // `-1` clears the owner (an admin may show every owner).
    final picked = await showDialog<int>(
      context: context,
      builder: (dialogContext) => WithTextController(
        text: scope.ownerId?.toString() ?? '',
        builder: (context, controller) => AlertDialog(
          title: Text(context.l10n.ownerScopeDialogTitle),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: controller,
              autofocus: true,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: context.l10n.ownerScopeIdLabel,
              ),
              validator: (value) {
                final id = int.tryParse(value?.trim() ?? '');
                return id == null || id <= 0
                    ? context.l10n.ownerScopeIdError
                    : null;
              },
            ),
          ),
          actions: [
            if (role == UserRole.admin && scope.ownerId != null)
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(-1),
                child: Text(context.l10n.ownerScopeShowAll),
              ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(context.l10n.commonCancel),
            ),
            FilledButton(
              onPressed: () {
                if (!(formKey.currentState?.validate() ?? false)) return;
                Navigator.of(
                  dialogContext,
                ).pop(int.parse(controller.text.trim()));
              },
              child: Text(context.l10n.commonSave),
            ),
          ],
        ),
      ),
    );
    if (picked == null) return;

    final prefs = ref.read(appPreferencesProvider);
    final key = ownerPrefKey(userId);
    final ownerId = picked == -1 ? null : picked;
    if (ownerId == null) {
      await prefs.remove(key);
    } else {
      await prefs.setInt(key, ownerId);
    }
    // The cached lists belong to the previous owner.
    ref.read(cacheStoreProvider).invalidateAll();
    ref.read(ownerScopeProvider.notifier).state = OwnerScope.forRole(
      role,
      ownerId,
    );
  }
}
