import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaseapp_ui/controllers/middleware/auth_controller.dart';
import 'package:kaseapp_ui/controllers/middleware/secure_storage.dart';
import 'package:kaseapp_ui/controllers/user_controller.dart';
import 'package:kaseapp_ui/models/register_model.dart';
import 'package:kaseapp_ui/models/user_model.dart';
import 'package:kaseapp_ui/repositories/register_repository.dart';
import 'package:kaseapp_ui/utils/dialogs/dialogs.dart';
import 'package:kaseapp_ui/utils/error/failure.dart';
import 'package:kaseapp_ui/views/home_view.dart';

class RegisterController extends GetxController {
  final AuthController authController = Get.find();
  final UserController userController = Get.find();
  final _registerRepository = RegisterRepository();
  final _secureStorage = SecureStorage();

  RxBool isLoading = false.obs;
  Future<void> register({required RegisterModel registerModel}) async {
  if (registerModel.password != registerModel.confirmPassword) {
    Get.snackbar("Error", "Passwords do not match");
    return;
  }
  final register = registerModel.copyWith(
    
  );

  final context = Get.context;
  isLoading.value = true;

  try {
    final response = await _registerRepository.register(registerModel: register);

    response.fold(
      (failure) {
        if (failure is NoInternetConnection) {
          ErrorDialog.showErrorDialog(
            context!,
            title: ' ${'Internet Connection'}',
            content: ' ${'No Internet Connection'}',
          );
        } else {
          print(' ${failure.message}');
          ErrorDialog.showErrorDialog(
            context!,
            title: 'Register Failed',
            content: ' ${failure.message}',
          );
        }
      },
(success) {
    final response = success as Map<String, dynamic>;
    if (response.containsKey('access_token') || response.containsKey('access_Token')) {
      final token = response['access_token'] ?? response['access_Token'];
      final user = UserModel.fromJson(response['user']);

      _secureStorage.writeData(key: 'token', value: token);
      _secureStorage.writeData(key: 'user', value: jsonEncode(response['user']));

      authController.setAuthenticated(true);
      userController.setUser(user);

      // Show welcome Snackbar
      Get.snackbar(
        "Welcome",
        "Welcome ${user.firstName}!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      // Navigate to HomePage
      Navigator.of(context!).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomePage()),
        (Route<dynamic> route) => false,
      );
    }
      },
    );
    } catch (e) {
    if (context != null) {
      ErrorDialog.showErrorDialog(
        context,
        title: 'Error',
        content: e.toString(),
      );
    }
  } finally {
    isLoading.value = false;
  }
}
}