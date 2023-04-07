import 'package:aacademic/ui/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:aacademic/utils/themes.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isSwitched = false;
  bool isDarkMode = false;
  late ThemeData selectedTheme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: const Text('Common'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: const Icon(Icons.language),
                title: const Text('Language'),
                value: const Text('English'),
              ),
              //SettingsTile.navigation(
              //    leading: const Icon(Icons.colorize),
              //    title: const Text('Dark Mode'),
              //    trailing: Switch(
              //      value: isDarkMode,
              //      onChanged: (value) {
              //        setState(() {
              //          isDarkMode = value;
              //        if (value) {
              //          selectedTheme = MyThemes.darkTheme;
              //        } else {
              //          selectedTheme = MyThemes.lightTheme;
              //        }});
              //      }
              //    )
              //  ),
              SettingsTile.navigation(
                leading: const Icon(Icons.lock),
                title: const Text('Log-in Page'),
                //onPressed: () {}
              )
            ],
          ),
        ],
      ),
    );
  }
}
