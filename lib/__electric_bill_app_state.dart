// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, avoid_print, deprecated_member_use, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_application_1/final_code.dart';

class ElectricBillAppState extends State<ElectricBillApp> {
  bool isDarkMode = false;
  bool notificationsEnabled = true;
  String selectedLanguage = "English";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: SettingsScreen(
        onThemeToggle: (value) {
          setState(() {
            isDarkMode = value;
          });
        },
        isDarkMode: isDarkMode, selectedLanguage: '', onLanguageChange: (String ) {  },
      ),
    );
  }
}
