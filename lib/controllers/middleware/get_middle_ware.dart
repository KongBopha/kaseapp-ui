import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import './auth_controller.dart';


class AuthMiddleware extends GetMiddleware {
  //final AuthController authController = Get.find<AuthController>();
  final List<String>? roleGuard;
  AuthMiddleware({this.roleGuard});
  @override
  int get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();
    if (!authController.auth) return const RouteSettings(name: '/login');
    if (roleGuard != null && !roleGuard!.contains(authController.role)) {
      return const RouteSettings(name: '/upgrade-role');
    }
    return null;
  }
}

