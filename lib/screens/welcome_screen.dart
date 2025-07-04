import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../widgets/animated_electricity_icon.dart';
import 'main_navigation_page.dart';

class WelcomePage extends StatelessWidget {
  final VoidCallback onThemeToggle;
  final bool isDarkMode;

  const WelcomePage({
    super.key,
    required this.onThemeToggle,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('electric_bill_optimizer'.tr()),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedElectricityIcon(),
            SizedBox(height: 20),
            Text(
              'electric_bill_optimizer'.tr(),
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.tealAccent,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainNavigationPage(
                      onThemeToggle: onThemeToggle,
                      isDarkMode: isDarkMode,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.tealAccent,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: Text(
                "lets_start".tr(),
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
