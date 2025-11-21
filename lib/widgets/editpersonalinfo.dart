import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kaseapp_ui/controllers/user_controller.dart';
import 'package:kaseapp_ui/utils/constants/app_image.dart';
import 'package:kaseapp_ui/utils/constants/images_converter.dart';

class EditPersonalInfoSheet extends StatefulWidget {
  const EditPersonalInfoSheet({super.key});

  @override
  State<EditPersonalInfoSheet> createState() => _EditPersonalInfoSheetState();
}

class _EditPersonalInfoSheetState extends State<EditPersonalInfoSheet> {
  final UserController userController = Get.find();
  final _formKey = GlobalKey<FormState>();
  final ImagesConverter imageConverter = ImagesConverter();

  late TextEditingController firstNameCtrl;
  late TextEditingController lastNameCtrl;
  late TextEditingController phoneCtrl;

  File? pickedImage;

  @override
  void initState() {
    super.initState();
    final user = userController.user;
    firstNameCtrl = TextEditingController(text: user.firstName ?? "");
    lastNameCtrl = TextEditingController(text: user.lastName ?? "");
    phoneCtrl = TextEditingController(text: user.phone ?? "");
  }

  @override
  void dispose() {
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      pickedImage = File(image.path);
      setState(() {}); // Preview update only
    } catch (e) {
      print("Pick image error: $e");
    }
  }

  Future<void> saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    await userController.updateProfile(
      image: pickedImage,
      firstName: firstNameCtrl.text.trim(),
      lastName: lastNameCtrl.text.trim(),
      phone: phoneCtrl.text.trim(),
    );

    Get.back();
    Get.snackbar(
      "Success",
      "Profile updated successfully",
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 18,
        right: 18,
        top: 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: 55,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Edit Personal Information",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _pickImage,
              child: Obx(() {
                final profileUrl = userController.user.profileUrl;
                return CircleAvatar(
                  radius: 50,
                  backgroundImage: pickedImage != null
                      ? FileImage(pickedImage!)
                      : (profileUrl != null && profileUrl.isNotEmpty)
                          ? NetworkImage(imageConverter.getProfileImageUrl(profileUrl))
                          : const AssetImage(AppImage.userProfile) as ImageProvider,
                  key: ValueKey(profileUrl ?? "default"),
                );
              }),
            ),
            const SizedBox(height: 8),
            Text("Tap to change photo", style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: firstNameCtrl,
                    decoration: const InputDecoration(labelText: "First Name"),
                    validator: (v) => v!.isEmpty ? "Required" : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: lastNameCtrl,
                    decoration: const InputDecoration(labelText: "Last Name"),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: phoneCtrl,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(labelText: "Phone"),
                  ),
                  const SizedBox(height: 10),
                  Obx(() {
                    return ElevatedButton(
                      onPressed: userController.loading.value ? null : saveChanges,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                        backgroundColor: Colors.teal,
                      ),
                      child: userController.loading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Save Changes"),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
