import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaseapp_ui/controllers/auth/login_controller.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final c = Get.put(LoginController());

  final phoneController = TextEditingController(text: "028498984");
  final passwordController = TextEditingController(text: "LorenWalson@#0011");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone',
                    prefixIcon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 24),
                c.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          final phone = phoneController.text.trim();
                          final password = passwordController.text.trim();

                          if (phone.isEmpty || password.isEmpty) {
                            Get.snackbar("Error", "Phone & Password required");
                            return;
                          }
                          c.login(phone, password);
                        },
                        child: const Text("Login"),
                      ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    // navigate to register page
                    Get.toNamed("/register");
                  },
                  child: const Text("Don't have an account? Register here"),
                )
              ],
            )),
      ),
    );
  }
}
