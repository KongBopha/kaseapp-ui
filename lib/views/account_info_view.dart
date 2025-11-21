import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kaseapp_ui/controllers/user_controller.dart';
import 'package:kaseapp_ui/utils/constants/app_image.dart';
import 'package:kaseapp_ui/utils/constants/base_api.dart';
import 'package:kaseapp_ui/widgets/app_bar/my_app_bar.dart';
import 'package:get/get.dart';

class AccountInformationView extends StatefulWidget {
  const AccountInformationView({super.key});

  @override
  State<AccountInformationView> createState() => _AccountInformationViewState();
}

class _AccountInformationViewState extends State<AccountInformationView> {
  final UserController _userController = Get.find();
  File? _image;

  Future _pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      File? img = File(image.path);
      setState(() {
        _image = img;
        _userController.updateProfile(image: _image);
      });
    } on PlatformException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const MyAppBar(
        title: "My profile",
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                width: size.width,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color.fromARGB(255, 240, 240, 245),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        //image
                        GestureDetector(
                          onTap: _pickImage,
                          child: Stack(
                            children: [
                              Container(
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: _image == null
                                      ? (_userController.user.profileUrl == null
                                          ? DecorationImage(
                                              image: AssetImage(
                                                AppImage.userProfile,
                                              ),
                                              fit: BoxFit.cover,
                                            )
                                          : DecorationImage(
                                              image: NetworkImage(
                                                  _userController
                                                          .user.profileUrl!
                                                          .contains("https")
                                                      ? _userController
                                                          .user.profileUrl!
                                                      : '${Constants.mainUrl}/storage/images/${_userController.user
                                                              .profileUrl!}'),
                                              fit: BoxFit.cover,
                                              opacity: 0.8,
                                            ))
                                      : DecorationImage(
                                          image: FileImage(_image!),
                                          fit: BoxFit.cover),
                                ),
                                width: size.width * 0.2,
                                height: size.width * 0.2,
                              ),
                              Positioned(
                                bottom: 8.0,
                                right: 8.0,
                                child: ClipOval(
                                  child: Material(
                                    color:
                                        const Color.fromARGB(255, 218, 196, 0),
                                    child: InkWell(
                                      onTap: () {},
                                      child: const Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 18,
                        ),
                        //name
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${_userController.user.firstName} ${_userController.user.lastName ?? ''}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "Phnom Penh, Cambodia",
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                  ),
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 58, 164, 183),
                                  ),
                                  child: const Text(
                                    "Seed",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Image.asset(
                        "lib/assets/qr-code.png",
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: size.height * 0.025,
              ),
              const Text(
                "Account information",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              AccountInformationWidget(
                title: "Full name",
                value:
                    "${_userController.user.firstName} ${_userController.user.lastName ?? ''}",
                editable: true,
              ),
              AccountInformationWidget(
                title: "Registered email",
                value: _userController.user.email ?? "---",
                editable: true,
              ),
              AccountInformationWidget(
                title: "Secure phone number",
                value: _userController.user.phone ?? "---",
              ),
              AccountInformationWidget(
                title: "User address",
                value: "Sangkat Orussey I, 7 Makara, Phnom Penh",
                editable: true,
              ),
              SizedBox(
                height: size.height * 0.025,
              ),
              const Text(
                "Business information",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              BusinessInformationWidget(
                title: "Business type",
                value: "Incomplete",
              ),
              BusinessInformationWidget(
                title: "Business name",
                value: "Momo Vegetable Shop",
                editable: true,
              ),
              AccountInformationWidget(
                title: "Business address",
                value: "Sangkat Orussey I, 7 Makara, Phnom Penh",
              ),
              BusinessInformationWidget(
                title: "Tax",
                value: "Incomplete",
                editable: true,
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BusinessInformationWidget extends StatelessWidget {
  const BusinessInformationWidget({
    super.key,
    this.editable = false,
    required this.value,
    required this.title,
  });

  final String title;
  final String value;
  final bool? editable;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 13,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 14, color: Colors.black45),
                ),
                const SizedBox(
                  height: 3,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Text(
                    value,
                    style: const TextStyle(fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                )
              ],
            ),
            if (editable!)
              Text(
                "Edit",
                style: TextStyle(
                  fontSize: 16,
                  decoration: TextDecoration.underline,
                ),
              ),
          ],
        ),
        SizedBox(
          height: 13,
        ),
      ],
    );
  }
}

class AccountInformationWidget extends StatelessWidget {
  const AccountInformationWidget({
    super.key,
    this.editable = false,
    required this.value,
    required this.title,
  });

  final String title;
  final String value;
  final bool? editable;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 13,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 14, color: Colors.black45),
                ),
                const SizedBox(
                  height: 3,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Text(
                    value,
                    style: TextStyle(fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                )
              ],
            ),
            if (editable!)
              Text(
                "Edit",
                style: TextStyle(
                  fontSize: 16,
                  decoration: TextDecoration.underline,
                ),
              ),
          ],
        ),
        const SizedBox(
          height: 13,
        ),
        const Divider(
          height: 1,
          color: Colors.black12,
        ),
      ],
    );
  }
}
