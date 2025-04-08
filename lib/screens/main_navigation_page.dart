import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import 'about_screen.dart';
import 'add_bill_screen.dart';

class MainNavigationPage extends StatefulWidget {
  final VoidCallback onThemeToggle;
  final bool isDarkMode;

  const MainNavigationPage(
      {super.key, required this.onThemeToggle, required this.isDarkMode});

  @override
  _MainNavigationPageState createState() => _MainNavigationPageState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('isDarkMode', isDarkMode));
  }
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Initialize the screens list inside the build method
    final List<Widget> screens = [
      HomeScreen(),
      ProfileScreen(),
      SettingsScreen(
        onThemeToggle: (isDark) {
          widget.onThemeToggle(); // Access widget here
        },
        isDarkMode: widget.isDarkMode, // Access widget here
      ),
      AboutScreen(),
      AddBillScreen(),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.tealAccent,
        unselectedItemColor: Colors.grey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Add Bill',
          ),
        ],
      ),
    );
  }
}
