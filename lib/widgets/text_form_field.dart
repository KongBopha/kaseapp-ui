import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField({
    super.key,
    required this.emptyText,
    required this.hintText,
    required this.title,
    this.obscureText = false,
    this.iconData = Icons.person_2_outlined,
    this.suffixIcon,
    this.value,
    this.controller,
    this.onChange,
    this.isPhoneNumberType = false,
    this.isNumber = false,
    this.isEmail = false,
  });

  final String title;
  final String emptyText;
  final String hintText;
  final String? value;
  final TextEditingController? controller;  
  final bool obscureText;
  final IconData iconData;
  final Widget? suffixIcon;
  final Function(String?)? onChange;
  final bool isPhoneNumberType;
  final bool isNumber;
  final bool isEmail;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller, //  
      initialValue: controller == null ? value : null,
      onChanged: onChange,
      obscureText: obscureText,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return emptyText;
        }

        if (isEmail) {
          final bool emailValid = RegExp(
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
              .hasMatch(value);
          if (!emailValid) return 'The email seems incorrect';
        }

        return null;
      },
      decoration: InputDecoration(
        prefixIcon: Icon(iconData),
        suffixIcon: suffixIcon,
        isDense: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        label: Text(
          title,
          style: const TextStyle(
            color: Color.fromARGB(221, 120, 120, 120),
          ),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.black26,
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black12),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black12),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 73, 100, 244),
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        errorStyle: const TextStyle(height: 0),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      ),
      keyboardType: isPhoneNumberType || isNumber ? TextInputType.phone : null,
      inputFormatters: [
        if (isPhoneNumberType) LengthLimitingTextInputFormatter(12),
        if (isPhoneNumberType)
          MaskedInputFormatter(
            '### ### ####',
            allowedCharMatcher: RegExp(r'[0-9]'),
          ),
        if (isNumber) LengthLimitingTextInputFormatter(12),
        if (isNumber)
          MaskedInputFormatter(
            '##########',
            allowedCharMatcher: RegExp(r'[0-9]'),
          ),
      ],
    );
  }
}
