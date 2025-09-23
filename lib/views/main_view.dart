// main_view.dart
import 'package:flutter/material.dart';
import 'package:kaseapp_ui/views/account_view.dart';
import 'package:kaseapp_ui/views/home_view.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int selectedIndex = 0;

  final body = [
    const HomePage(),
    AccountView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.green, 
        onTap: (index) => setState(() => selectedIndex = index),
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
