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
  final UserController _userController = Get.find();
  final _formKey = GlobalKey<FormState>();
  final ImagesConverter _imageConverter = ImagesConverter();  

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;
  File? _pickedImage;

  @override
  void initState() {
    super.initState();
    final user = _userController.user;
    _firstNameController = TextEditingController(text: user.firstName ?? '');
    _lastNameController = TextEditingController(text: user.lastName ?? '');
    _phoneController = TextEditingController(text: user.phone ?? '');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _pickedImage = File(picked.path);
      });
    }
  }

  void _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    if (_pickedImage != null) {
      await _userController.updateProfile(_pickedImage!);
    }

    _userController.user.firstName = _firstNameController.text;
    _userController.user.lastName = _lastNameController.text;
    _userController.user.phone = _phoneController.text;

    Get.back(); // Close bottom sheet
    Get.snackbar(
      'Success',
      'Profile updated successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _userController.user;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: 60,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Edit Personal Info",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // 👤 Profile image with converter
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 45,
                backgroundImage: _pickedImage != null
                    ? FileImage(_pickedImage!)
                    : (user.profileUrl != null && user.profileUrl!.isNotEmpty
                        ? NetworkImage(_imageConverter.getProfileImageUrl(user.profileUrl))
                        : const AssetImage(AppImage.userProfile)
                            as ImageProvider),
              ),
            ),

            const SizedBox(height: 10),
            Text("Tap to change photo", style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 20),

            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(labelText: "First Name"),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(labelText: "Last Name"),
                  ),
                  const SizedBox(height: 10),  
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(labelText: "Phone"),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _saveChanges,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 45),
                    ),
                    child: const Text("Save Changes"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
