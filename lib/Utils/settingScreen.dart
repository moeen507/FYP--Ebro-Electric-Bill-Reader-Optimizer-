// ignore_for_file: sized_box_for_whitespace, camel_case_types, file_names

import 'package:flutter/material.dart';

class settingsScr extends StatefulWidget {
  const settingsScr({super.key});

  @override
  State<settingsScr> createState() => _settingsScrState();
}

class _settingsScrState extends State<settingsScr> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Text("Settings Screen"),

            Container(
              width: 150,
              child: Column(
                children: [
                  Text("Change Color"),
                  Divider(thickness: 3,),
                  Text("Change Theme"),
                  Divider(thickness: 3,),
                  Text("Change Password")
              
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}