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
                leading: const Icon(Icons.privacy_tip_outlined),
                title: const Text('Priivacy Policy'),
                value: const Text('English'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onPressed: (BuildContext context) {
                  Navigator.push(context, MaterialPageRoute(builder: ((context) => const LoginPage())));
                },
              ),
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
