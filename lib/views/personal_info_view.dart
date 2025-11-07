import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaseapp_ui/controllers/user_controller.dart';
import 'package:kaseapp_ui/utils/constants/app_image.dart';
import 'package:kaseapp_ui/utils/constants/images_converter.dart';
import 'package:kaseapp_ui/widgets/app_bar/my_app_bar.dart';
import 'package:kaseapp_ui/widgets/editpersonalinfo.dart';

class PersonalInfoView extends StatelessWidget {
  const PersonalInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find();
    final ImagesConverter imageConverter = ImagesConverter();

    return Scaffold(
      appBar: MyAppBar(
        title: "Personal Information".tr,
        automaticallyImplyLeading: true,
      ),
      body: Obx(() {
        final user = userController.user;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile photo
              CircleAvatar(
                radius: 55,
                backgroundImage: user.profileUrl == null ||
                        user.profileUrl!.isEmpty
                    ? const AssetImage(AppImage.userProfile) as ImageProvider
                    : NetworkImage(imageConverter.getProfileImageUrl(user.profileUrl)),
              ),
              const SizedBox(height: 20),

              // Full name
              Text(
                "${user.firstName ?? ''} ${user.lastName ?? ''}".trim(),
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Role
              Text(
                user.role,
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 20),

              const Divider(thickness: 1),

              const SizedBox(height: 10),
              InfoTile(title: "First Name", value: user.firstName ?? "Not provided"),
              InfoTile(title: "Last Name", value: user.lastName ?? "Not provided"),
              InfoTile(title: "Email", value: user.email ?? "Not provided"),
              InfoTile(title: "Phone", value: user.phone ?? "Not provided"),
              InfoTile(title: "Last Name", value: user.lastName ?? "Not provided"),

              const SizedBox(height: 30),

              ElevatedButton.icon(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (_) => const EditPersonalInfoSheet(),
                  );
                },
                icon: const Icon(Icons.edit),
                label: const Text("Edit Information"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),

            ],
          ),
        );
      }),
    );
  }
}

class InfoTile extends StatelessWidget {
  final String title;
  final String value;

  const InfoTile({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
      subtitle: Text(value,
          style: const TextStyle(color: Colors.black87, fontSize: 15)),
      leading: const Icon(Icons.info_outline, color: Colors.teal),
      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
    );
  }
}
