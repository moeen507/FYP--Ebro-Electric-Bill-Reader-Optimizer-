import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final Function(bool) onThemeToggle;
  final bool isDarkMode;

  const SettingsScreen(
      {super.key, required this.onThemeToggle, required this.isDarkMode});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkModeState;

  _SettingsScreenState() : isDarkModeState = false;

  @override
  void initState() {
    super.initState();
    isDarkModeState = widget.isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          SwitchListTile(
            title: Text('Dark Mode'),
            value: isDarkModeState,
            onChanged: (value) {
              setState(() {
                isDarkModeState = value;
              });
              widget.onThemeToggle(value);
            },
          ),
          ListTile(
            leading: Icon(Icons.language, color: Colors.tealAccent),
            title: Text('Language'),
            subtitle: Text('Select app language'),
            onTap: () {
              // Add language selection logic
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications, color: Colors.tealAccent),
            title: Text('Notifications'),
            subtitle: Text('Manage app notifications'),
            onTap: () {
              // Add notification settings logic
            },
          ),
          ListTile(
            leading: Icon(Icons.privacy_tip, color: Colors.tealAccent),
            title: Text('Privacy Policy'),
            subtitle: Text('View our privacy policy'),
            onTap: () {
              // Navigate to privacy policy page
            },
          ),
          ListTile(
            leading: Icon(Icons.help, color: Colors.tealAccent),
            title: Text('Help & Support'),
            subtitle: Text('Get help or contact support'),
            onTap: () {
              // Navigate to help & support page
            },
          ),
        ],
      ),
    );
  }
}
