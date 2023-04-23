import 'package:aacademic/ui/login/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:aacademic/utils/themes.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class ThemePage extends StatefulWidget {
  const ThemePage({Key? key}) : super(key: key);

  @override
  State<ThemePage> createState() => _ThemePageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String? data;

  void _loadData() async {
    final _loadedData =
        await rootBundle.loadString('assets/privacy_policy.txt');
    setState(() {
      data = _loadedData;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: const Text('Account'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: const Icon(Icons.vpn_key),
                trailing: const Icon(Icons.chevron_right),
                title: const Text('Change Password'),
                onPressed: (BuildContext context) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => const LoginPage())));
                },
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.language),
                trailing: const Icon(Icons.chevron_right),
                title: const Text('Language'),
                value: const Text('LANG VARIABLE HERE'),
                onPressed: (BuildContext context) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => const LoginPage())));
                },
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.logout),
                trailing: const Icon(Icons.chevron_right),
                title: const Text('Logout'),
              ),
            ],
          ),
          SettingsSection(
            title: const Text('Settings'),
            tiles: <SettingsTile>[
              SettingsTile(
                leading: const Icon(Icons.apps),
                title: const Text('Grid Style'),
              ),
              SettingsTile.navigation(
                  leading: const Icon(Icons.water_drop),
                  title: const Text('Themes'),
                  onPressed: (BuildContext context) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => const ThemePage())));
                  }),
            ],
          ),
          SettingsSection(
            title: const Text('About'),
            tiles: <SettingsTile>[
              SettingsTile(
                  trailing: const Icon(Icons.chevron_right),
                  title: const Text('Privacy Policy'),
                  onPressed: (BuildContext context) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            scrollable: true,
                            title: const Text('Privacy Policy'),
                            content: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(data ?? 'empty'),
                            ),
                          );
                        });
                  }),
              SettingsTile(
                title: const Text('Version'),
                value: const Text('0.0.1'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ThemePageState extends State<ThemePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: SettingsList(
          sections: [
            SettingsSection(title: const Text("Themes"), tiles: <SettingsTile>[
              SettingsTile(
                  trailing: const Icon(Icons.check),
                  title: const Text("AAC.AI Theme"),
                  onPressed: (BuildContext context) {
                    Provider.of<ThemeModel>(context, listen: false)
                        .setLightTheme();
                  }),
              SettingsTile(
                  trailing: const Icon(Icons.check),
                  title: const Text("Dark Theme"),
                  onPressed: (BuildContext context) {
                    Provider.of<ThemeModel>(context, listen: false)
                        .setDarkTheme();
                  }),
              SettingsTile(
                  trailing: const Icon(Icons.check),
                  title: const Text("Protonopia Theme"),
                  onPressed: (BuildContext context) {
                    Provider.of<ThemeModel>(context, listen: false)
                        .setProTheme();
                  }),
              SettingsTile(
                  trailing: const Icon(Icons.check),
                  title: const Text("Tritanopia Theme"),
                  onPressed: (BuildContext context) {
                    Provider.of<ThemeModel>(context, listen: false)
                        .setTriTheme();
                  }),
              SettingsTile(
                  trailing: const Icon(Icons.check),
                  title: const Text("Achromatopsia Theme"),
                  onPressed: (BuildContext context) {
                    Provider.of<ThemeModel>(context, listen: false)
                        .setAchroTheme();
                  }),
            ])
          ],
        ));
  }
}
