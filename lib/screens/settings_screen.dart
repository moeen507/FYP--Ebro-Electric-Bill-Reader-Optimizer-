import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class SettingsScreen extends StatefulWidget {
  final Function(bool) onThemeToggle;
  final bool isDarkMode;

  const SettingsScreen({
    super.key,
    required this.onThemeToggle,
    required this.isDarkMode,
  });

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkModeState;
  final Map<String, Locale> languageLocales = {
    'English': Locale('en'),
    'Urdu': Locale('ur'),
    'Arabic': Locale('ar'),
  };

  String get selectedLanguage => languageLocales.entries
      .firstWhere((entry) => entry.value == context.locale,
          orElse: () => languageLocales.entries.first)
      .key;

  _SettingsScreenState() : isDarkModeState = false;

  @override
  void initState() {
    super.initState();
    isDarkModeState = widget.isDarkMode;
  }

  void _showLanguageDialog() async {
    String? language = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('select_language'.tr()),
          children: languageLocales.keys.map((lang) {
            return SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, lang);
              },
              child: Text(lang),
            );
          }).toList(),
        );
      },
    );
    if (language != null && languageLocales[language] != context.locale) {
      context.setLocale(languageLocales[language]!);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('settings'.tr()),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          SwitchListTile(
            title: Text('dark_mode'.tr()),
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
            title: Text('language'.tr()),
            subtitle: Text('Current: $selectedLanguage'),
            onTap: _showLanguageDialog,
          ),
          ListTile(
            leading: Icon(Icons.notifications, color: Colors.tealAccent),
            title: Text('notifications'.tr()),
            subtitle: Text('manage_notifications'.tr()),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.privacy_tip, color: Colors.tealAccent),
            title: Text('privacy_policy'.tr()),
            subtitle: Text('view_privacy_policy'.tr()),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.help, color: Colors.tealAccent),
            title: Text('help_support'.tr()),
            subtitle: Text('get_help'.tr()),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
