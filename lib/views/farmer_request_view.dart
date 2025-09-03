import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaseapp_ui/controllers/user_controller.dart';
import 'package:kaseapp_ui/views/home_view.dart';
import '../controllers/middleware/auth_controller.dart';

class FarmerRequestView extends StatelessWidget {
  FarmerRequestView({super.key});

  final AuthController authController = Get.find<AuthController>();
  final UserController userController = Get.find<UserController>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();
  final TextEditingController coverController = TextEditingController();
  final TextEditingController logoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Farmer Request Form")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Farm Name"),
            ),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(labelText: "Address"),
            ),
            TextField(
              controller: aboutController,
              decoration: const InputDecoration(labelText: "About Farm"),
              maxLines: 3,
            ),
            TextField(
              controller: coverController,
              decoration: const InputDecoration(labelText: "Cover Image URL(Optional) "),
            ),
            TextField(
              controller: logoController,
              decoration: const InputDecoration(labelText: "Logo Image URL(Optional) "),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await userController.upgradeToFarmer(
                  name: nameController.text,
                  address: addressController.text,
                  about: aboutController.text,
                  cover: coverController.text,
                  logo: logoController.text,
                );
                authController.upgradeRole('farmer');
                Get.snackbar(
                  "Congratulations you are become",
                  "Congratulations you are become ${userController.user.role}!",
                  snackPosition: SnackPosition.BOTTOM,
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
