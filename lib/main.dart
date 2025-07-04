// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:easy_localization/easy_localization.dart';
import 'screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('ur'), Locale('ar')],
      path: 'assets/lang',
      fallbackLocale: Locale('en'),
      child: ElectricBillApp(),
    ),
  );
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
      title: "EBRO",
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      localizationsDelegates: context.localizationDelegates, // <-- FIXED HERE
      supportedLocales: context.supportedLocales,
      locale: context.locale,
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
