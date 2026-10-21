import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/utils/dates.dart';
import 'package:estate_app/features/rental_applications/models/application_form.dart';
import 'package:flutter/material.dart';

/// The input for one form question, with its own validation. Text and number
/// answers live in [controller]; yes/no, choice and date answers are [value],
/// reported through [onChanged].
class AnswerField extends StatelessWidget {
  const AnswerField({
    super.key,
    required this.field,
    required this.controller,
    required this.value,
    required this.onChanged,
  });

  final ApplicationFormField field;
  final TextEditingController controller;
  final Object? value;
  final ValueChanged<Object?> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final required = field.isRequired == true;
    final label = '${field.label ?? ''}${required ? ' *' : ''}';
    String? requiredCheck(Object? v) =>
        required && (v == null || (v is String && v.trim().isEmpty))
        ? l10n.publicApplyAnswerRequired
        : null;

    switch (field.fieldType) {
      case ApplicationFieldType.boolean:
        // A yes/no question always has an answer.
        return SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(field.label ?? ''),
          value: value as bool? ?? false,
          onChanged: onChanged,
        );
      case ApplicationFieldType.select
          when (field.options?.isNotEmpty ?? false):
        return DropdownButtonFormField<String>(
          initialValue: value as String?,
          isExpanded: true,
          decoration: InputDecoration(labelText: label),
          hint: Text(l10n.publicApplyChoose),
          items: [
            for (final option in field.options!)
              DropdownMenuItem(value: option, child: Text(option)),
          ],
          onChanged: onChanged,
          validator: requiredCheck,
        );
      case ApplicationFieldType.date:
        return FormField<DateTime>(
          initialValue: value as DateTime?,
          validator: requiredCheck,
          builder: (state) => InkWell(
            borderRadius: AppRadii.md,
            onTap: () async {
              final now = DateTime.now();
              final picked = await showDatePicker(
                context: context,
                initialDate: state.value ?? now,
                firstDate: DateTime(now.year - 100),
                lastDate: DateTime(now.year + 5),
              );
              if (picked == null) return;
              state.didChange(picked);
              onChanged(picked);
            },
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: label,
                errorText: state.errorText,
                suffixIcon: const Icon(Icons.calendar_today_outlined),
              ),
              isEmpty: state.value == null,
              child: state.value == null
                  ? null
                  : Text(shortDate(context, state.value!)),
            ),
          ),
        );
      case ApplicationFieldType.number:
        return TextFormField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(labelText: label),
          validator: (v) {
            final text = (v ?? '').trim();
            if (text.isEmpty) return requiredCheck(text);
            final number = num.tryParse(text);
            return number == null || !number.isFinite
                ? l10n.publicApplyNumberInvalid
                : null;
          },
        );
      case _:
        final long = field.fieldType == ApplicationFieldType.textarea;
        return TextFormField(
          controller: controller,
          minLines: long ? 3 : 1,
          maxLines: long ? 6 : 1,
          textCapitalization: TextCapitalization.sentences,
          textInputAction: long
              ? TextInputAction.newline
              : TextInputAction.next,
          decoration: InputDecoration(
            labelText: label,
            alignLabelWithHint: long,
          ),
          validator: requiredCheck,
        );
    }
  }
}
