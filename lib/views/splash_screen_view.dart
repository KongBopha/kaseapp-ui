import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaseapp_ui/controllers/middleware/auth_controller.dart';
import 'package:kaseapp_ui/configs/routes/routes.dart';

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({super.key});

  @override
  State<SplashScreenView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashScreenView> {
  final AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _startApp();
  }

  Future<void> _startApp() async {
    // Wait until storage is loaded
    await authController.hydrateFromStorage();

    // Small delay for splash effect
    await Future.delayed(const Duration(seconds: 2));

    print('Auth after storage/API: ${authController.auth}');
    if (authController.auth) {
      Get.offAllNamed(AppRoutes.mainView);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('lib/assets/app_logo.png',height: 80, width: 80,),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
