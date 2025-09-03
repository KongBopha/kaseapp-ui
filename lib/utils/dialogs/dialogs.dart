import 'package:flutter/material.dart';
import '/utils/dialogs/android/alert_dialog.dart';

class ErrorDialog {
  static void showErrorDialog(BuildContext context,
      {String? title, required String content}) async {
    return showDialog(
      context: context,
      builder: (context) => AndroidAlertDialog(
        title: title,
        content: content,
      ),
    );
  }
}
