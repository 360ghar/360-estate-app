import 'dart:async';

import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_card.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/features/settings/domain/entities/app_locale.dart';
import 'package:estate_app/features/settings/domain/entities/app_theme_mode.dart';
import 'package:estate_app/features/settings/presentation/controllers/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SettingsController>();

    return AppScaffold(
      appBar: AppBar(title: Text(context.l10n.settingsTitle)),
      body: Obx(
        () => ListView(
          padding: EdgeInsets.zero,
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.themeSectionTitle,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  RadioGroup<AppThemeMode>(
                    groupValue: controller.themeMode.value,
                    onChanged: (v) {
                      if (v == null) return;
                      unawaited(controller.setTheme(v));
                    },
                    child: Column(
                      children: [
                        RadioListTile<AppThemeMode>(
                          value: AppThemeMode.system,
                          title: Text(context.l10n.themeSystem),
                        ),
                        RadioListTile<AppThemeMode>(
                          value: AppThemeMode.light,
                          title: Text(context.l10n.themeLight),
                        ),
                        RadioListTile<AppThemeMode>(
                          value: AppThemeMode.dark,
                          title: Text(context.l10n.themeDark),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.languageSectionTitle,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  RadioGroup<String?>(
                    groupValue: controller.locale.value?.languageCode,
                    onChanged: (v) {
                      switch (v) {
                        case null:
                          unawaited(controller.setAppLocale(null));
                        case 'en':
                          unawaited(
                            controller.setAppLocale(
                              const AppLocale(languageCode: 'en'),
                            ),
                          );
                        case 'hi':
                          unawaited(
                            controller.setAppLocale(
                              const AppLocale(languageCode: 'hi'),
                            ),
                          );
                        default:
                          return;
                      }
                    },
                    child: Column(
                      children: [
                        RadioListTile<String?>(
                          value: null,
                          title: Text(context.l10n.languageSystem),
                        ),
                        RadioListTile<String?>(
                          value: 'en',
                          title: Text(context.l10n.languageEnglish),
                        ),
                        RadioListTile<String?>(
                          value: 'hi',
                          title: Text(context.l10n.languageHindi),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
