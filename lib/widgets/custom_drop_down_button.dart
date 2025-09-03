import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomDropDownButtonFormField<T> extends StatelessWidget {
  CustomDropDownButtonFormField({
    super.key,
    this.value,
    required this.items,
    this.onChanged,
    this.validator,
    this.onSaved,
    this.hintText,
    this.isValidate = true,
    this.border,
  }) {
    border = OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.black45, width: 0.2),
      borderRadius: BorderRadius.circular(10),
    );
  }

  final Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final Function(T?)? onSaved;
  final List<DropdownMenuItem<T>>? items;
  final String? hintText;
  final T? value;
  bool isValidate;
  InputBorder? border;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.065,
      child: DropdownButtonFormField<T>(
        isDense: true,
        decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color.fromARGB(255, 31, 126, 255), width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 15),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            enabledBorder: border,
            border: border,
            errorStyle: const TextStyle(height: 0),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red.shade400, width: 1),
              borderRadius: BorderRadius.circular(10),
            )),
        value: value,
        hint: Text(hintText ?? ''),
        onChanged: onChanged ??
            (T? data) {
              // onChanged(T);
            },
        validator: (T? t) {
          if (isValidate) {
            if (t == null) {
              return '';
              // return 'Please select $hintText';
            }
          }
          return null;
        },
        items: items,
        onSaved: onSaved,
      ),
    );
  }
}
