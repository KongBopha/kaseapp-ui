import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaseapp_ui/controllers/middleware/auth_controller.dart';
import 'package:kaseapp_ui/controllers/middleware/secure_storage.dart';
import 'package:kaseapp_ui/controllers/user_controller.dart';
import 'package:kaseapp_ui/models/login_model.dart';
import 'package:kaseapp_ui/models/user_model.dart';
import 'package:kaseapp_ui/repositories/login_repository.dart';
import 'package:kaseapp_ui/utils/dialogs/dialogs.dart';
import 'package:kaseapp_ui/views/main_view.dart';

class LoginController extends GetxController{
  final AuthController auth = Get.find();
  final UserController userController = Get.find();
  final _loginRepos = LoginRepository();
  final _secureStorage = SecureStorage();

  RxBool isLoading = false.obs;
 Future<void> login(String loginInput, String password) async {
  final context = Get.context;
  isLoading.value = true;

  try {
    final result = await _loginRepos.login(
      loginModel: LoginModel(
        login: loginInput,
        password: password,
      ),
    );

    result.fold(
      (failure) {
        ErrorDialog.showErrorDialog(
          context!,
          title: 'Login Failed',
          content: failure.message,
        );
      },
      (success) async {
        final response = success as Map<String, dynamic>;
        if (response.containsKey('access_token')) {
          final token = response['access_token'];
          final user = UserModel.fromJson(response['user']);

          await _secureStorage.writeData(key: 'token', value: token);
          await _secureStorage.writeData(key: 'user', value: jsonEncode(response['user']));

          auth.setAuthenticated(true);
          userController.setUser(user);

          Get.snackbar(
            "Welcome back",
            "Welcome back ${user.firstName}!",
            snackPosition: SnackPosition.TOP,
            // ignore: deprecated_member_use
            backgroundColor: Colors.green.withOpacity(0.8),
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );

          Future.delayed(const Duration(milliseconds: 500), () {
            Get.offAll(() => const MainView());
          });
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