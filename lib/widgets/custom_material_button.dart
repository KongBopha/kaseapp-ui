import 'package:flutter/material.dart';

class CustomMaterialButton extends StatelessWidget {
  const CustomMaterialButton({
    super.key,
    required this.onTap,
    required this.child,
    this.width,
    this.height,
    this.color,
    this.textColor,
    this.padding,
    this.borderRadius,
  });

  final Function() onTap;
  final Color? color;
  final Color? textColor;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final Widget child;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: width,
      height: height,
      elevation: 0,
      hoverElevation: 0,
      focusElevation: 0,
      highlightElevation: 0,
      color: color ?? Colors.transparent,
      textColor: textColor,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.zero,
      ),
      padding: padding ?? const EdgeInsets.all(0),
      onPressed: onTap,
      child: child,
    );
  }
}
