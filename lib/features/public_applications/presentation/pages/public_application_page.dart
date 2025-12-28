import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PublicApplicationPage extends StatelessWidget {
  const PublicApplicationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final slug = Get.parameters['slug'] ?? '';

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.publicApplicationTitle)),
      body: Center(child: Text(context.l10n.publicApplicationSlug(slug))),
    );
  }
}
