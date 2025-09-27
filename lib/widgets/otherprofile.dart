import 'package:flutter/material.dart';
 import 'package:kaseapp_ui/models/user_model.dart';

class OtherProfileScreen extends StatelessWidget {
  final UserModel user;
  const OtherProfileScreen({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(user.firstName ?? 'Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${user.firstName} ${user.lastName}'),
            Text('Email: ${user.email}'),
            Text('Role: ${user.role}'),
            if (user.vendor != null) ...[
              Text('Vendor: ${user.vendor?.companyName}'),
              Text('Type: ${user.vendor?.vendorType}'),
              Text('Address: ${user.vendor?.address}'),
            ],
            if (user.farm != null) ...[
              Text('Farm: ${user.farm?.name}'),
              Text('Address: ${user.farm?.address}'),
              Text('Status: ${user.farm?.status}'),
            ]
          ],
        ),
      ),
    );
  }
}
