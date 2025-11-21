import 'package:flutter/material.dart';
import 'package:kaseapp_ui/widgets/forminputfield.dart';

class LocationInputField extends StatelessWidget {
  final TextEditingController controller;
  final bool isLoading;
  final VoidCallback onPickMap;

  const LocationInputField({
    super.key,
    required this.controller,
    this.isLoading = false,
    required this.onPickMap,
  });

  @override
  Widget build(BuildContext context) {
    return FormInputField(
      label: 'Delivery Location',
      controller: controller,
      hint: 'Enter location or use GPS',
      maxLines: 2,
      suffixIcon: isLoading
          ? Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
            )
          : ElevatedButton.icon(
              icon: const Icon(Icons.map_outlined),
              label: const Text('Select on Map'),
              onPressed: onPickMap,
            ),
      validator: (value) => (value == null || value.isEmpty) ? 'Please enter or select location' : null,
    );
  }
}
