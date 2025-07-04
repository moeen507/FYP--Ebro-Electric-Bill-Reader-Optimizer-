import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import 'about_screen.dart';
import 'add_bill_screen.dart';

class MainNavigationPage extends StatefulWidget {
  final VoidCallback onThemeToggle;
  final bool isDarkMode;

  const MainNavigationPage({
    super.key,
    required this.onThemeToggle,
    required this.isDarkMode,
  });

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
    final List<Widget> screens = [
      HomeScreen(),
      ProfileScreen(),
      SettingsScreen(
        onThemeToggle: (isDark) {
          widget.onThemeToggle();
        },
        isDarkMode: widget.isDarkMode,
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
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'home'.tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'profile'.tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'settings'.tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'about'.tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'add_bill'.tr(),
          ),
        ],
      ),
    );
  }
}
