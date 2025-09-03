import 'package:flutter/material.dart';

class AndroidAlertDialog extends StatelessWidget {
  const AndroidAlertDialog({super.key, this.title, required this.content});

  final String? title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title ?? ''),
      content: SizedBox(
        // height: MediaQuery.of(context).size.height * 0.08,
        width: MediaQuery.of(context).size.width,
        child: Container(
          child: Text(content),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        )
      ],
    );
  }
}
