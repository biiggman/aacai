import 'package:aacademic/ui/login/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:aacademic/utils/themes.dart';

//Declaration of pages
//Settings page declaration
class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

//Theme page declaration
class ThemePage extends StatefulWidget {
  const ThemePage({Key? key}) : super(key: key);

  @override
  State<ThemePage> createState() => _ThemePageState();
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

//************************************************************** */

//Password Reset page declaration
class PasswordResetPage extends StatefulWidget {
  const PasswordResetPage({Key? key}) : super(key: key);

  @override
  State<PasswordResetPage> createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: SettingsList(sections: [
          SettingsSection(
              title: const Text("Change Password"),
              tiles: <SettingsTile>[
                SettingsTile(
                  title: const Text('Password Reset'),
                ),
              ])
        ]));
  }
}

//************************************************************** */

//Email Reset page declaration
class UsernameResetPage extends StatefulWidget {
  const UsernameResetPage({Key? key}) : super(key: key);

  @override
  State<UsernameResetPage> createState() => _UsernameResetPageState();
}

class _UsernameResetPageState extends State<UsernameResetPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: SettingsList(sections: [
          SettingsSection(
              title: const Text("Change Email"),
              tiles: <SettingsTile>[
                SettingsTile(
                  title: const Text('Email Reset'),
                ),
              ])
        ]));
  }
}

//************************************************************** */

//Gridview changer declaration
class GridviewPage extends StatefulWidget {
  const GridviewPage({Key? key}) : super(key: key);

  @override
  State<GridviewPage> createState() => _GridviewPageState();
}

class _GridviewPageState extends State<GridviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: SettingsList(sections: [
          SettingsSection(
              title: const Text("Grid Style"),
              tiles: <SettingsTile>[
                SettingsTile(
                  title: const Text('3x3'),
                  //ON PRESSED GOES HERE
                ),
                SettingsTile(title: const Text('4x4')
                    //ON PRESSED GOES HERE
                    )
              ])
        ]));
  }
}

//************************************************************** */

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
                          builder: ((context) => const PasswordResetPage())));
                },
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.account_circle),
                trailing: const Icon(Icons.chevron_right),
                title: const Text('Change Email'),
                onPressed: (BuildContext context) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => const UsernameResetPage())));
                },
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.logout),
                trailing: const Icon(Icons.chevron_right),
                title: const Text('Logout'),
                onPressed: (BuildContext context) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => const LoginPage())));
                },
              ),
            ],
          ),
          SettingsSection(
            title: const Text('Settings'),
            tiles: <SettingsTile>[
              SettingsTile(
                leading: const Icon(Icons.apps),
                title: const Text('Grid Style'),
                onPressed: (BuildContext context) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => const GridviewPage())));
                },
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
