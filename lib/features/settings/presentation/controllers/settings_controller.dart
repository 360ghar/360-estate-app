import 'dart:async';

import 'package:estate_app/core/logger/app_logger.dart';
import 'package:estate_app/features/settings/domain/entities/app_locale.dart';
import 'package:estate_app/features/settings/domain/entities/app_theme_mode.dart';
import 'package:estate_app/features/settings/domain/usecases/get_locale_usecase.dart';
import 'package:estate_app/features/settings/domain/usecases/get_theme_mode_usecase.dart';
import 'package:estate_app/features/settings/domain/usecases/set_locale_usecase.dart';
import 'package:estate_app/features/settings/domain/usecases/set_theme_mode_usecase.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  SettingsController({
    required GetThemeModeUseCase getThemeMode,
    required SetThemeModeUseCase setThemeMode,
    required GetLocaleUseCase getLocale,
    required SetLocaleUseCase setLocale,
  }) : _getThemeMode = getThemeMode,
       _setThemeMode = setThemeMode,
       _getLocale = getLocale,
       _setLocale = setLocale;

  final GetThemeModeUseCase _getThemeMode;
  final SetThemeModeUseCase _setThemeMode;
  final GetLocaleUseCase _getLocale;
  final SetLocaleUseCase _setLocale;

  final Rx<AppThemeMode> themeMode = AppThemeMode.system.obs;
  final Rx<AppLocale?> locale = Rx<AppLocale?>(null);

  ThemeMode get flutterThemeMode => switch (themeMode.value) {
    AppThemeMode.system => ThemeMode.system,
    AppThemeMode.light => ThemeMode.light,
    AppThemeMode.dark => ThemeMode.dark,
  };

  Locale? get flutterLocale {
    final pref = locale.value;
    if (pref == null) return null;
    return Locale(pref.languageCode, pref.countryCode);
  }

  @override
  void onInit() {
    super.onInit();
    unawaited(_load());
  }

  Future<void> setTheme(AppThemeMode mode) async {
    themeMode.value = mode;
    await _setThemeMode(mode);
    Get.changeThemeMode(flutterThemeMode);
  }

  Future<void> setAppLocale(AppLocale? newLocale) async {
    locale.value = newLocale;
    await _setLocale(newLocale);

    final flutter = flutterLocale;
    if (flutter == null) {
      final deviceLocale = Get.deviceLocale;
      if (deviceLocale != null) {
        await Get.updateLocale(deviceLocale);
      }
      return;
    }

    await Get.updateLocale(flutter);
  }

  Future<void> _load() async {
    try {
      themeMode.value = await _getThemeMode();
      Get.changeThemeMode(flutterThemeMode);

      locale.value = await _getLocale();
      final flutter = flutterLocale;
      if (flutter != null) await Get.updateLocale(flutter);
    } catch (e, st) {
      AppLogger.w('Failed to load settings', error: e, stackTrace: st);
    }
  }
}
