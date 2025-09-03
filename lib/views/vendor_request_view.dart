import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaseapp_ui/controllers/user_controller.dart';
import 'package:kaseapp_ui/views/home_view.dart';
import '../controllers/middleware/auth_controller.dart';

class VendorRequestView extends StatelessWidget {
  VendorRequestView({super.key});

  final AuthController authController = Get.find<AuthController>();
  final UserController userController = Get.find<UserController>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();
  final TextEditingController vendorTypeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Vendor Request Form")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Shop Name"),
            ),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(labelText: "Address"),
            ),
            TextField(
              controller: aboutController,
              decoration: const InputDecoration(labelText: "About Shop"),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: vendorTypeController,
              decoration: const InputDecoration(labelText: "Vendor Type"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await userController.upgradeToVendor(
                  name: nameController.text,
                  address: addressController.text,
                  description: aboutController.text,
                  vendorType: vendorTypeController.text,
                );
                authController.upgradeRole('vendor');
                Get.snackbar( 
                  "Congratulations you are become",
                  "Congratulations you are become ${userController.user.role}!",
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: Colors.green.withOpacity(0.8),
                  colorText: Colors.white,
                  duration: const Duration(seconds: 3),
                );

                Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const HomePage()),
                (Route<dynamic> route) => false,
              );
              },
              child: const Text("Submit Request"),
            ),
          ],
        ),
      ),
    );
  }
}
