import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const  MyAppBar(
      {super.key,
      this.title,
      this.titleTextStyle,
      this.backIcon,
      this.backgroundColor,
      this.actions,
      this.elevation,
      this.iconColor,
      this.iconSize,
      this.automaticallyImplyLeading = true});

    //final NotificationRepository _notificationRepository;  


  final String? title;
  final Color? backgroundColor;
  final IconData? backIcon;
  final Color? iconColor;
  final List<Widget>? actions;
  final TextStyle? titleTextStyle;
  final double? elevation;
  final bool automaticallyImplyLeading;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: elevation ?? 0,
      centerTitle: true,
      leading: automaticallyImplyLeading
          ? IconButton(
              onPressed: () => Get.back(),
              icon: Icon(
                backIcon ?? Icons.arrow_back_ios_new_outlined,
                color: iconColor ?? Colors.black87,
                size: iconSize ?? 24,
              ),
            )
          : Container(),
      backgroundColor: backgroundColor ?? Colors.white,
      title: Text(
        title ?? '',
        style: titleTextStyle ?? const TextStyle(color: Colors.black87),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(Get.height * 0.06);
}
