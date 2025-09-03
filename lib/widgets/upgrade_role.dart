
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class UpgradeRolePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final role = args?['role'] ?? 'farmer'; // default

    return Scaffold(
      appBar: AppBar(title: Text('Upgrade to $role')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            if (role == 'farmer') {
              // Call upgradeToFarmer()
            } else if (role == 'vendor') {
              // Call upgradeToVendor()
            }
          },
          child: Text('Upgrade Now to $role'),
        ),
      ),
    );
  }
}
