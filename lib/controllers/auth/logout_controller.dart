import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaseapp_ui/controllers/middleware/auth_controller.dart';
import 'dart:developer';

class LogoutController extends GetxController {
  AuthController? _authController;

  @override
  void onInit() {
    super.onInit();
    _initAuthController();
  }

  void _initAuthController() {
    if (Get.isRegistered<AuthController>()) {
      _authController = Get.find<AuthController>();
    }
  }

  /// Logout user safely
  Future<void> logout() async {
    try {
      if (_authController == null && Get.isRegistered<AuthController>()) {
        _initAuthController();
      }

      if (_authController != null && _authController!.auth) {
        log('LogoutController: Starting logout process');
         await _authController!.signOut();
      } else {
        log('LogoutController: User not authenticated, navigate to login');
        Get.offAllNamed('/login');
      }
    } catch (e) {
      log('LogoutController: Error during logout: $e');
      Get.offAllNamed('/login');
    }
  }

  /// Logout with confirmation
  void logoutWithConfirmation() {
    Get.dialog(
      AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Get.back();
              await logout();
              Get.snackbar(
                'Logged out',
                'You have been logged out successfully',
                snackPosition: SnackPosition.BOTTOM,
                duration: const Duration(seconds: 2),
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
