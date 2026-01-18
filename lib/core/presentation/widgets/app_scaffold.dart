import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.padding = AppInsets.screen,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.safeArea = true,
    this.scrollable = false,
    this.background,
    this.extendBodyBehindAppBar = false,
    this.resizeToAvoidBottomInset = true,
  });

  final PreferredSizeWidget? appBar;
  final Widget body;
  final EdgeInsetsGeometry padding;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final bool safeArea;
  final bool scrollable;
  final Widget? background;
  final bool extendBodyBehindAppBar;
  final bool resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    Widget content = Padding(padding: padding, child: body);
    // Apply SafeArea before SingleChildScrollView so padding respects safe areas
    if (safeArea) content = SafeArea(child: content);
    if (scrollable) content = SingleChildScrollView(child: content);

    final scaffoldBody = background == null
        ? content
        : Stack(
            children: [
              Positioned.fill(child: background!),
              content,
            ],
          );

    return Scaffold(
      appBar: appBar,
      body: scaffoldBody,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    );
  }
}
