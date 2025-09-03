import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'farmer_request_view.dart';
import 'vendor_request_view.dart';

class UpgradeRoleView extends StatelessWidget {
  UpgradeRoleView({super.key});

  @override
  Widget build(BuildContext context) {
    // Read which role user tried to access
    final String requestedRole = Get.arguments ?? 'farmer';

    return Scaffold(
      appBar: AppBar(title: const Text("Upgrade Role")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _showUpgradeDialog(context, requestedRole);
          },
          child: const Text("Upgrade Account"),
        ),
      ),
    );
  }

  void _showUpgradeDialog(BuildContext context, String role) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Upgrade Role"),
        content: Text(
            "You do not have access to this feature. Would you like to upgrade your account to $role?"),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back(); // close dialog
              _redirectToRequestForm(role);
            },
            child: Text("Become $role"),
          ),
        ],
      ),
    );
  }

  void _redirectToRequestForm(String role) {
    if (role == 'farmer') {
      Get.to(() => FarmerRequestView());
    } else if (role == 'vendor') {
      Get.to(() => VendorRequestView());
    }
  }
}
