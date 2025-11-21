import 'package:flutter/material.dart';
class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    super.key,
    required this.emptyText,
    required this.hintText,
    required this.title,
    this.obscureText = false,
    this.iconData = Icons.person,
    this.suffixIcon,
    this.value,
    this.controller,
    this.onChange,
    this.isPhoneNumberType = false,
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
  final Function(String)? onChange;
  final bool isPhoneNumberType;
  final bool isEmail;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _isPasswordVisible = false;
  String? _errorMessage;

  void _validateLive(String value) {
    if (value.isEmpty) {
      setState(() => _errorMessage = widget.emptyText);
      return;
    }

    if (widget.isEmail) {
      final validEmail = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
      ).hasMatch(value);
      if (!validEmail) {
        setState(() => _errorMessage = "Invalid email format");
        return;
      }
    }

    if (widget.isPhoneNumberType) {
      final cleaned = value.replaceAll(' ', '');
      if (!RegExp(r'^[0-9]*$').hasMatch(cleaned)) {
        setState(() => _errorMessage = "Invalid phone number");
        return;
      }
    }

    setState(() => _errorMessage = null);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title,
            style: const TextStyle(
                fontSize: 14, color: Color.fromARGB(255, 90, 90, 90))),
        const SizedBox(height: 6),
        TextField(
          controller: widget.controller,
          obscureText: widget.obscureText ? !_isPasswordVisible : false,
          keyboardType: widget.isPhoneNumberType
              ? TextInputType.number
              : TextInputType.text,
          onChanged: (value) {
            _validateLive(value);
            widget.onChange?.call(value);
          },
          decoration: InputDecoration(
            hintText: widget.hintText,
            prefixIcon: Icon(widget.iconData),
            suffixIcon: widget.obscureText
                ? IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () =>
                        setState(() => _isPasswordVisible = !_isPasswordVisible),
                  )
                : widget.suffixIcon,
            filled: true,
            fillColor: const Color(0xfff5f6fa),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                  color: _errorMessage == null ? Colors.grey : Colors.red),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: _errorMessage == null
                    ? const Color.fromARGB(255, 73, 100, 244)
                    : Colors.red,
                width: 2,
              ),
            ),
          ),
        ),
        if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Text(
              _errorMessage!,
              style: const TextStyle(
                  color: Colors.red, fontSize: 12, fontWeight: FontWeight.w400),
            ),
          ),
        const SizedBox(height: 12),
      ],
    );
  }
}
