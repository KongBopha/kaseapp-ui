import 'package:flutter/material.dart';

class CustomTimePickerField extends StatefulWidget {
  final String labelText;
  final TextEditingController controller;
  final TimeOfDay? time;
  final Function(TimeOfDay) timeChange;
  final Function() timeDelete;
  final bool editable;

  const CustomTimePickerField({
    super.key,
    required this.labelText,
    required this.controller,
    required this.timeChange,
    required this.timeDelete,
    required this.time,
    required this.editable
  });

  @override
  State<CustomTimePickerField> createState() => _CustomTimePickerFieldState();
}

class _CustomTimePickerFieldState extends State<CustomTimePickerField> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        onTap: widget.editable ? () async {
          TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: widget.time ?? const TimeOfDay(hour: 0, minute: 0),
          );
          setState(() {
            if (pickedTime != null) {
              widget.timeChange(pickedTime);
              widget.controller.text = "${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')} ${pickedTime.period.name.toUpperCase()}";
            }
          });
        } : () {},
        readOnly: true,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          labelText: widget.labelText,
          border: const OutlineInputBorder(),
          isDense: true,
          suffixIcon: IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () {
              widget.timeDelete();
              widget.controller.clear();
            },
          ),
        ),
        controller: widget.controller,
      ),
    );
  }
}