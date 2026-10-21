import 'package:flutter/material.dart';

/// Owns a [TextEditingController] for a dialog.
///
/// A dialog that hands its controller back to the code that opened it must not
/// dispose the controller when `showDialog` returns: the dialog is still on
/// screen while it animates out, and a disposed controller throws when the
/// field rebuilds. Build the whole dialog inside [builder], and the controller
/// is disposed with the dialog's own state.
class WithTextController extends StatefulWidget {
  const WithTextController({super.key, required this.builder, this.text});

  /// The starting text.
  final String? text;

  /// Builds the dialog. [controller] lives as long as the dialog does.
  final Widget Function(BuildContext context, TextEditingController controller)
  builder;

  @override
  State<WithTextController> createState() => _WithTextControllerState();
}

class _WithTextControllerState extends State<WithTextController> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.text,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _controller);
}
