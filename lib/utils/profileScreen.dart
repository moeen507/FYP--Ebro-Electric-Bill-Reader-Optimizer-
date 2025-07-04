// ignore_for_file: camel_case_types, file_names

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class profileScr extends StatefulWidget {
  const profileScr({super.key});

  @override
  State<profileScr> createState() => _profileScrState();
}

class _profileScrState extends State<profileScr> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("profile_screen".tr()),
            SizedBox(
              height: 500,
              width: 300,
              child: Column(
                children: [
                  Icon(Icons.person, size: 50),
                  SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "username".tr(),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "email".tr(),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text("logout".tr()),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
