// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Utils/homeScreen.dart';
import 'package:flutter_application_1/Utils/profileScreen.dart';
import 'package:flutter_application_1/Utils/settingScreen.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedindex=0;

  final List<Widget> widgetOptions = const [
    homeScr(),
    profileScr(),
    settingsScr()
  ];

  void _onItemTapped(int index){
    setState(() {
      _selectedindex=index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bottom Navigation"),
        centerTitle: true,
      ),
      body: widgetOptions.elementAt(_selectedindex),
      bottomNavigationBar : BottomNavigationBar(
        showSelectedLabels: true,
        selectedItemColor: Colors.blue,
        showUnselectedLabels: true, 
        unselectedItemColor: Colors.deepPurple,
        items: [
          BottomNavigationBarItem(icon:  Icon(Icons.home),label: "Home"),
          BottomNavigationBarItem(icon:   Icon(Icons.person),label: "Profile"),
          BottomNavigationBarItem(icon:   Icon(Icons.settings),label: "Settings"),
        ],
        currentIndex: _selectedindex,
        onTap: _onItemTapped,),
    );
  }
}