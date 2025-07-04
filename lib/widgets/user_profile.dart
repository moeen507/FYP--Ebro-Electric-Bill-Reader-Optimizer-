import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class UserProfile extends StatelessWidget {
  final VoidCallback onLogout;

  const UserProfile({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/profile.png'),
          ),
          SizedBox(height: 20),
          Text(
            'welcome_user'.tr(),
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: onLogout,
            child: Text('logout'.tr()),
          ),
        ],
      ),
    );
  }
}
