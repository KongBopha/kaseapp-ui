import 'package:flutter/material.dart';
import 'package:kaseapp_ui/configs/Routes/routes.dart';
import 'package:kaseapp_ui/configs/routes/routes.dart';
import 'package:kaseapp_ui/controllers/auth/logout_controller.dart';
import 'package:kaseapp_ui/utils/constants/app_image.dart';
import 'package:kaseapp_ui/utils/constants/base_api.dart';
import 'package:kaseapp_ui/utils/constants/base_api.dart';
import 'package:kaseapp_ui/controllers/auth/login_controller.dart';
import 'package:kaseapp_ui/controllers/user_controller.dart';
import 'package:kaseapp_ui/widgets/app_bar/my_app_bar.dart';
import 'package:get/get.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  final Color actionButtonColor = Colors.black87;
  final double actionButtonSize = 27;

  final UserController _userController = Get.find();
  final LogoutController logoutController = Get.put(LogoutController());

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
              // onPressed: () => Get.toNamed(AppRoutes.language),
              icon: Icon(
                Icons.language,
                color: actionButtonColor,
                size: actionButtonSize,
              )),
          // IconButton(
          //   onPressed: () => Get.toNamed(AppRoutes.setting),
          //   icon: Icon(Icons.settings,
          //       color: actionButtonColor, size: actionButtonSize),
          // ),
          const SizedBox(width: 10)
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: size.width,  
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(
                    () => Material(
                      borderRadius: BorderRadius.circular(50),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: _userController.user.profileUrl == null
                            ? CircleAvatar(
                                radius: size.height * 0.06,
                                backgroundImage: const AssetImage(
                                  AppImage.userProfile,
                                ),
                                key: const ValueKey("default"),
                              )
                            : CircleAvatar(
                                radius: size.height * 0.06,
                                backgroundImage: NetworkImage(_userController
                                        .user.profileUrl!
                                        .contains("https")
                                    ? _userController.user.profileUrl!
                                    : '${Constants.mainUrl}/storage/images/${_userController.user.profileUrl!}'),
                                key: ValueKey(_userController.user.profileUrl!
                                        .contains("https")
                                    ? _userController.user.profileUrl!
                                    : '${Constants.mainUrl}/storage/images/${_userController.user.profileUrl!}'),
                              ),
                      ),
                    ),
                  ),
                  Obx(
                    () => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          // userController.user.fullName!,
                          _userController.user.firstName != null
                              ? "${_userController.user.firstName} ${_userController.user.lastName}"
                              : "No Username".tr,
                          // "Pink Panther",
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(_userController.user.role),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Feature(
              title: "User information".tr,
              showIcon: true,
              // onTap: () => Get.toNamed(
              //   // '/my${AppRoutes.userInformationView}',
              // ),
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 10,
            ),
            Feature(
              title: "Accepted Order",
              showIcon: true,
              // onTap: () => Get.toNamed(
              //   // '/my${AppRoutes.acceptedOrderView}',
              // ),
            ),

            const Padding(
              padding: EdgeInsets.only(left: 20.0, top: 10, bottom: 20),
              child: Text(
                "connect with other services",
                style: TextStyle(
                  color: Colors.black45,
                ),
              ),
            ),
            const Feature(
              title: "Customer Service",
              showIcon: false,
            ),
            const SizedBox(
              height: 10,
            ),
            const Feature(
              title: "Support Center",
              showIcon: false,
            ),
            const SizedBox(
              height: 10,
            ),
            const Feature(
              title: "Address",
              showIcon: false,
            ),
            const SizedBox(
              height: 10,
            ),
            if (_userController.user.firstName != null)
              Feature(
                title: "Log Out".tr,
                showIcon: false,
                onTap: () {
                  logoutController.logout();
                },
              ),
          ],
        ),
      ),
    );
  }
}

class Feature extends StatelessWidget {
  const Feature({
    super.key,
    required this.title,
    required this.showIcon,
    this.onTap,
  });

  final String title;
  final bool showIcon;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
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
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16.0,
                  // fontWeight: FontWeight.w500,
                ),
              ),
              if (showIcon)
                const Icon(
                  Icons.arrow_forward_ios_outlined,
                  size: 16,
                  color: Colors.grey,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
