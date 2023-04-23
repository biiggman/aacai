import 'package:aacademic/ui/login/login_page.dart';
import 'package:aacademic/ui/login/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:aacademic/firebase/fire_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:aacademic/utils/themes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../../main.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isSwitched = false;
  bool isDarkMode = false;
  late ThemeData selectedTheme;
  User? user = FirebaseAuth.instance.currentUser;

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
                title: const Text('Profile Page'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onPressed: (BuildContext context) {
                  if (user != null) {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: ((context) => ProfilePage(
                                  user: user!,
                                ))));
                  }
                },
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.lock),
                title: const Text('Log-in Page'),
                //onPressed: () {}
              )
            ],
          ),
          SettingsSection(title: const Text('Languages'), tiles: <SettingsTile>[
            SettingsTile.navigation(
              leading: const Icon(Icons.language),
              title: const Text('Spanish'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onPressed: (BuildContext context) {
                setState(() {
                  currentLanguage = "es-Es";
                });
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                ScaffoldMessenger.of(context)
                    .showSnackBar(FireAuth.customSnackBar(
                  content: 'Language set to Spanish',
                  color: Colors.green,
                ));
              },
            ),
            SettingsTile.navigation(
              leading: const Icon(Icons.language),
              title: const Text('English'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onPressed: (BuildContext context) {
                setState(() {
                  currentLanguage = "en-US";
                });
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                ScaffoldMessenger.of(context)
                    .showSnackBar(FireAuth.customSnackBar(
                  content: 'Language set to English',
                  color: Colors.green,
                ));
              },
            ),
          ])
        ],
      ),
    );
  }
}
