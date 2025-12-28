import 'package:estate_app/app/routes/app_routes.dart';
import 'package:estate_app/core/config/app_config.dart';
import 'package:estate_app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GuestMiddleware extends GetMiddleware {
  GuestMiddleware({super.priority = 0});

  bool _isSignedIn() {
    final config = Get.find<AppConfig>();
    if (!config.isSupabaseConfigured) return false;

    if (Get.isRegistered<AuthController>()) {
      return Get.find<AuthController>().isAuthenticated;
    }

    try {
      return Supabase.instance.client.auth.currentSession != null;
    } catch (_) {
      return false;
    }
  }

  @override
  RouteSettings? redirect(String? route) {
    if (_isSignedIn()) {
      return const RouteSettings(name: Routes.home);
    }
    return null;
  }
}
