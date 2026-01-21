import 'package:flutter/material.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({super.key, this.label});

  final String? label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final loader = SizedBox(
      width: 22,
      height: 22,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(scheme.primary),
      ),
    );
    if (label == null) return loader;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        loader,
        const SizedBox(width: 12),
        Flexible(child: Text(label!)),
      ],
    );
  }
}
