import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaseapp_ui/controllers/auth/logout_controller.dart';
import 'package:kaseapp_ui/controllers/user_controller.dart';
import 'package:kaseapp_ui/utils/constants/app_image.dart';
import 'package:kaseapp_ui/utils/constants/base_api.dart';
import 'package:kaseapp_ui/widgets/app_bar/my_app_bar.dart';

class AccountView extends StatelessWidget {
  AccountView({Key? key}) : super(key: key);

  final UserController _userController = Get.find();
  final LogoutController _logoutController = Get.put(LogoutController());

  // Helper to get profile image URL
  String getProfileImageUrl(String? profileUrl) {
    if (profileUrl == null || profileUrl.isEmpty) return AppImage.userProfile;

    if (profileUrl.startsWith("http")) return profileUrl;
    final cleanPath =
        profileUrl.replaceAll(RegExp(r'^/storage/profile_photos/'), '');
    return '${Constants.mainUrl}/storage/profile_photos/$cleanPath';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.language, color: Colors.black87, size: 27),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile section
            Container(
              width: size.width,
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Obx(
                    () => Material(
                      borderRadius: BorderRadius.circular(50),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: CircleAvatar(
                          radius: size.height * 0.06,
                          backgroundImage:
                              _userController.user.profileUrl == null ||
                                      _userController
                                          .user.profileUrl!.isEmpty
                                  ? const AssetImage(AppImage.userProfile)
                                      as ImageProvider
                                  : NetworkImage(getProfileImageUrl(
                                      _userController.user.profileUrl)),
                          key: ValueKey(
                              _userController.user.profileUrl ?? "default"),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          _userController.user.firstName != null
                              ? "${_userController.user.firstName} ${_userController.user.lastName ?? ''}"
                              : "No Username".tr,
                          style: const TextStyle(
                              fontSize: 28, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _userController.user.role,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Feature(title: "User information".tr, showIcon: true),
            const SizedBox(height: 10),
            Feature(title: "Accepted Order", showIcon: true),
            const Padding(
              padding: EdgeInsets.only(left: 20, top: 10, bottom: 20),
              child: Text(
                "connect with other services",
                style: TextStyle(color: Colors.black45),
              ),
            ),
            const Feature(title: "Customer Service", showIcon: false),
            const SizedBox(height: 10),
            const Feature(title: "Support Center", showIcon: false),
            const SizedBox(height: 10),
            const Feature(title: "Address", showIcon: false),
            const SizedBox(height: 10),
            Obx(
              () => _userController.user.firstName != null
                  ? Feature(
                      title: "Log Out".tr,
                      showIcon: false,
                      onTap: () {
                        _logoutController.logoutWithConfirmation();
                      },
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

class Feature extends StatelessWidget {
  const Feature(
      {Key? key, required this.title, required this.showIcon, this.onTap})
      : super(key: key);

  final String title;
  final bool showIcon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          width: size.width,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 240, 240, 245),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 16)),
              if (showIcon)
                const Icon(Icons.arrow_forward_ios_outlined,
                    size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
