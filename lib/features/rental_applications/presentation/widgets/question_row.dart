import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/features/rental_applications/models/application_form.dart';
import 'package:estate_app/features/rental_applications/presentation/application_field_type_ui.dart';
import 'package:flutter/material.dart';

/// One question of an application form: its type glyph, the question, and
/// "Yes or no · Required". [onRemove] adds a remove button.
class QuestionRow extends StatelessWidget {
  const QuestionRow({super.key, required this.field, this.onRemove});

  final ApplicationFormField field;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final type = field.fieldType ?? ApplicationFieldType.text;
    final options = field.options ?? const <String>[];
    final facts = [
      type.text(l10n),
      if (field.isRequired == true) l10n.applicationFormRequired,
      if (type == ApplicationFieldType.select && options.isNotEmpty)
        options.join(', '),
    ];
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: onRemove == null ? AppSpacing.sm : 0,
      ),
      child: Row(
        children: [
          ExcludeSemantics(
            child: Icon(type.icon, color: context.colors.onSurfaceVariant),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  field.label ?? l10n.applicationFormQuestionLabel,
                  style: context.text.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  facts.join('  ·  '),
                  style: context.text.bodySmall?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (onRemove != null)
            IconButton(
              tooltip: l10n.applicationFormRemoveQuestion,
              icon: const Icon(Icons.close_rounded),
              color: context.colors.onSurfaceVariant,
              onPressed: onRemove,
            ),
        ],
      ),
    );
  }
}
