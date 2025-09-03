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
import 'package:kaseapp_ui/utils/error/failure.dart';
import 'package:kaseapp_ui/views/home_view.dart';
import 'package:kaseapp_ui/views/main_view.dart';

class LoginController extends GetxController{
  final AuthController auth = Get.find();
  final UserController userController = Get.find();
  final _loginRepos = LoginRepository();
  final _secureStorage = SecureStorage();

  RxBool isLoading = false.obs;
  Future<void> login(String phone, String password) async {

    final context = Get.context;
    isLoading.value = true;
    try{
      final result = await _loginRepos.login(loginModel:LoginModel(
        password: password, 
        phone: phone
        ));

      result.fold(
      (failure) {
        // Handle login failure
        if(failure is NoInternetConnection){
          ErrorDialog.showErrorDialog(
            context!,
            content: "No internet connection");
        }
        else{
          print('${failure.message}');
          ErrorDialog.showErrorDialog(
            context!,
            title: 'Login Failed',
            content: '${failure.message}',
          );
        }
      },
          (success) {
               // Handle login success
            final response = success as Map<String, dynamic>;

            if (response.containsKey('access_token')) {
              final token = response['access_token'];
              final user = UserModel.fromJson(response['user']);

              _secureStorage.writeData(key: 'token', value: token);
              _secureStorage.writeData(key: 'user', value: jsonEncode(response['user']));

              auth.setAuthenticated(true);
              userController.setUser(user);

              Get.snackbar(
                "Welcome back",
                "Welcome back ${user.firstName}!",
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.green.withOpacity(0.8),
                colorText: Colors.white,
                duration: const Duration(seconds: 3),
              );

              // Navigate to HomePage
              Navigator.of(context!).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const MainView()),
                (Route<dynamic> route) => false,
              );
            }
          }
        );

    }catch(e){
      // Handle error
      if(context != null){
        ErrorDialog.showErrorDialog(
        context,
        title: 'Error',
        content: e.toString(),
      );
      }
    }
    finally {
      isLoading.value = false;
    }
  }
}