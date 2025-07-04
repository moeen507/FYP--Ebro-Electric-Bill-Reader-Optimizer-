import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../widgets/login_form.dart';
import '../widgets/user_profile.dart';
import 'guest_mode_page.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('profile'.tr()),
        backgroundColor: Colors.black,
      ),
      body: isLoggedIn
          ? UserProfile(
              onLogout: () {
                setState(() {
                  isLoggedIn = false;
                });
              },
            )
          : LoginForm(
              onLogin: () {
                setState(() {
                  isLoggedIn = true;
                });
              },
              onGuestMode: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GuestModePage()),
                );
              },
            ),
    );
  }
}
