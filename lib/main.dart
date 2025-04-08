import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';

void main() {
  runApp(ElectricBillApp());
}

class ElectricBillApp extends StatefulWidget {
  const ElectricBillApp({super.key});

  @override
  _ElectricBillAppState createState() => _ElectricBillAppState();
}

class _ElectricBillAppState extends State<ElectricBillApp> {
  bool isDarkMode = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: WelcomePage(
        onThemeToggle: () {
          setState(() {
            isDarkMode = !isDarkMode;
          });
        },
        isDarkMode: isDarkMode,
      ),
    );
  }
}