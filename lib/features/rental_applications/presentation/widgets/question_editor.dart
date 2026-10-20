import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/features/rental_applications/models/application_form.dart';
import 'package:estate_app/features/rental_applications/presentation/application_field_type_ui.dart';
import 'package:flutter/material.dart';

/// Writes one question: its text, the kind of answer, the choices of a choice
/// question, and whether an answer is required. [onAdd] gets the question
/// without an id; the caller gives it one.
class QuestionEditor extends StatefulWidget {
  const QuestionEditor({super.key, required this.onAdd});

  final ValueChanged<ApplicationFormField> onAdd;

  @override
  State<QuestionEditor> createState() => _QuestionEditorState();
}

class _QuestionEditorState extends State<QuestionEditor> {
  final _label = TextEditingController();
  final _options = TextEditingController();
  ApplicationFieldType _type = ApplicationFieldType.text;
  bool _required = false;
  String? _labelError;
  String? _optionsError;

  @override
  void dispose() {
    _label.dispose();
    _options.dispose();
    super.dispose();
  }

  void _add() {
    final l10n = context.l10n;
    final label = _label.text.trim();
    final options = _options.text
        .split(',')
        .map((o) => o.trim())
        .where((o) => o.isNotEmpty)
        .toList();
    final isChoice = _type == ApplicationFieldType.select;
    setState(() {
      _labelError = label.isEmpty ? l10n.applicationFormQuestionRequired : null;
      _optionsError = isChoice && options.isEmpty
          ? l10n.applicationFormOptionsRequired
          : null;
    });
    if (_labelError != null || _optionsError != null) return;
    widget.onAdd(
      ApplicationFormField(
        label: label,
        fieldType: _type,
        isRequired: _required,
        options: isChoice ? options : null,
      ),
    );
    setState(() {
      _label.clear();
      _options.clear();
      _type = ApplicationFieldType.text;
      _required = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: _label,
          textCapitalization: TextCapitalization.sentences,
          textInputAction: TextInputAction.done,
          onChanged: (_) {
            if (_labelError != null) setState(() => _labelError = null);
          },
          decoration: InputDecoration(
            labelText: l10n.applicationFormQuestionLabel,
            hintText: l10n.applicationFormQuestionHint,
            errorText: _labelError,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          l10n.applicationFormAnswerType,
          style: context.text.labelLarge?.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final type in ApplicationFieldType.values)
              ChoiceChip(
                avatar: Icon(type.icon, size: 18),
                label: Text(type.text(l10n)),
                selected: _type == type,
                showCheckmark: false,
                onSelected: (_) => setState(() {
                  _type = type;
                  _optionsError = null;
                }),
              ),
          ],
        ),
        if (_type == ApplicationFieldType.select) ...[
          const SizedBox(height: AppSpacing.lg),
          TextFormField(
            controller: _options,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: l10n.applicationFormOptions,
              helperText: l10n.applicationFormOptionsHelp,
              errorText: _optionsError,
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.sm),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.applicationFormRequiredAnswer),
          value: _required,
          onChanged: (value) => setState(() => _required = value),
        ),
        const SizedBox(height: AppSpacing.xs),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: OutlinedButton.icon(
            onPressed: _add,
            icon: const Icon(Icons.add_rounded),
            label: Text(l10n.applicationFormAddQuestion),
          ),
        ),
      ],
    );
  }
}
