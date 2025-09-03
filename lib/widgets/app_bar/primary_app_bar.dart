import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kaseapp_ui/configs/themes/app_theme.dart';

class PrimaryAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PrimaryAppBar({
    super.key,
    this.titleTextStyle,
    this.backIcon,
    this.backgroundColor,
    this.actions,
    this.elevation,
    required this.onSearch,
    this.onTap,
    this.automaticallyImplyLeading = true,
    this.onInputSearch,
    this.initValueSearch,
    this.autoFocus = false,
    this.isEnableSearch = false,
  });

  final Colors? backgroundColor;
  final IconData? backIcon;
  final List<Widget>? actions;
  final TextStyle? titleTextStyle;
  final double? elevation;
  final bool automaticallyImplyLeading;
  final Function() onSearch;
  final Function()? onTap;
  final Function(String?)? onInputSearch;
  final String? initValueSearch;
  final bool autoFocus;
  final bool isEnableSearch;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      // leadingWidth: automaticallyImplyLeading
      //     ? MediaQuery.of(context).size.width * 0.08
      //     : 0,
      elevation: elevation ?? 0,
      centerTitle: true,
      titleSpacing: 2,
      backgroundColor: Colors.white,
      leading: automaticallyImplyLeading
          ? IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(
                backIcon ?? Icons.arrow_back,
                color: Colors.black87,
                size: 30,
              ),
            )
          : const Padding(
              padding: EdgeInsets.all(8),
              child: ClipOval(
                child: Image(
                  image: AssetImage('lib/assets/logo.jpg'),
                ),
              )),
      /* SizedBox(
              width: 30,
              height: 30,
              child:*/

      title: Text("KaseApp",
        style: TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold
        ),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(Get.height * 0.075);
}
