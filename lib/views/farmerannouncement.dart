import 'package:flutter/material.dart';
import 'package:kaseapp_ui/widgets/tabcontrollerbar.dart';

class FarmerScreen extends StatefulWidget {
  const FarmerScreen({super.key});
  
  @override
  State<FarmerScreen> createState() => _FarmerScreenState();
}

class _FarmerScreenState extends State<FarmerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farmer Management'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: const TabControllerWidget(), 
    );
  }
}