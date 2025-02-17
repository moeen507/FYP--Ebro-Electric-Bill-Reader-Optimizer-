// ignore_for_file: camel_case_types, file_names

import 'package:flutter/material.dart';

class homeScr extends StatefulWidget {
  const homeScr({super.key});

  @override
  State<homeScr> createState() => _homeScrState();
}

class _homeScrState extends State<homeScr> {
  @override
  Widget build(BuildContext context) {
    return Scaffold
    (
      body:  GridView.count(
        crossAxisCount: 4,
        mainAxisSpacing: 16, //between columns
        crossAxisSpacing: 8, //between rows
        children: List.generate(16, (index) {
          return Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.blueGrey.shade300,
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Container(
                  //   width: 50,
                  //   height: 50,
                  //   child: Icon(Icons.person),
                  // ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    '${index + 1}',
                    style: TextStyle(
                        fontSize: 16,
                        // fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  // Text(
                  //   'hello',
                  //   style: TextStyle(
                  //       fontSize: 16,
                  //       // fontWeight: FontWeight.bold,
                  //       color: Colors.black),
                  // ),
                ],
              ));
        }),
     ),
);
}
}
