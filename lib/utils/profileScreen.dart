// ignore_for_file: camel_case_types, file_names

import 'package:flutter/material.dart';

class profileScr extends StatefulWidget {
  const profileScr({super.key});

  @override
  State<profileScr> createState() => _profileScrState();
}

class _profileScrState extends State<profileScr> {
  @override
  Widget build(BuildContext context) {
    return Scaffold
    (
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Profile Screen"),
            SizedBox(
              height: 500,
              width: 300,
              //color: Colors.blue,
              child: Column(
                children: [
                  Icon(Icons.person,size: 50,),
                  SizedBox(height: 10,),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "UserName"
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Email"
                    ),
                  ),
                  SizedBox(height: 10,),
                  ElevatedButton(onPressed: (){}, child: Text("Logout"))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}