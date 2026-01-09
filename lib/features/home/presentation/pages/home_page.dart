import 'package:estate_app/core/presentation/widgets/app_loader.dart';
import 'package:estate_app/features/auth/domain/entities/auth_user.dart';
import 'package:estate_app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:estate_app/features/home/presentation/pages/owner_dashboard_page.dart';
import 'package:estate_app/features/home/presentation/pages/rm_dashboard_page.dart';
import 'package:estate_app/features/home/presentation/pages/tenant_dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Obx(() {
      final user = authController.state.value.data;
      if (user == null) {
        return const Scaffold(
          body: Center(child: AppLoader()),
        );
      }

      switch (user.role) {
        case UserRole.admin: // Owner
          return const OwnerDashboardPage();
        case UserRole.agent: // RM
          return const RMDashboardPage();
        case UserRole.user: // Tenant
          return const TenantDashboardPage();
        case UserRole.unknown:
          // Fallback or error - maybe default to Tenant view or show "Role not assigned"
          return const Center(child: Text('Role not assigned'));
      }
    });
  }
}
