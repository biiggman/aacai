import 'package:aacademic/ui/login/login_page.dart';

import 'package:aacademic/ui/settings/email_reset_page.dart';
import 'package:aacademic/ui/settings/password_reset_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:aacademic/firebase/fire_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:aacademic/utils/themes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../../main.dart';

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
                  title: const Text("AAC.AI Theme"),
                  onPressed: (BuildContext context) {
                    Provider.of<ThemeModel>(context, listen: false)
                        .setLightTheme();
                    ScaffoldMessenger.of(context).removeCurrentSnackBar();
                    ScaffoldMessenger.of(context)
                        .showSnackBar(FireAuth.customSnackBar(
                      content: 'Default Theme Activated!',
                      color: Colors.green,
                    ));
                  }),
              SettingsTile(
                  title: const Text("Dark Theme"),
                  onPressed: (BuildContext context) {
                    Provider.of<ThemeModel>(context, listen: false)
                        .setDarkTheme();
                    ScaffoldMessenger.of(context).removeCurrentSnackBar();
                    ScaffoldMessenger.of(context)
                        .showSnackBar(FireAuth.customSnackBar(
                      content: 'Dark Mode Activated!',
                      color: Colors.green,
                    ));
                  }),
              SettingsTile(
                  title: const Text("Protonopia Theme"),
                  onPressed: (BuildContext context) {
                    Provider.of<ThemeModel>(context, listen: false)
                        .setProTheme();
                    ScaffoldMessenger.of(context).removeCurrentSnackBar();
                    ScaffoldMessenger.of(context)
                        .showSnackBar(FireAuth.customSnackBar(
                      content: 'Protonopia Mode Activated!',
                      color: Colors.green,
                    ));
                  }),
              SettingsTile(
                  title: const Text("Tritanopia Theme"),
                  onPressed: (BuildContext context) {
                    Provider.of<ThemeModel>(context, listen: false)
                        .setTriTheme();
                    ScaffoldMessenger.of(context).removeCurrentSnackBar();
                    ScaffoldMessenger.of(context)
                        .showSnackBar(FireAuth.customSnackBar(
                      content: 'Tritanopia Mode Activated!',
                      color: Colors.green,
                    ));
                  }),
              SettingsTile(
                  title: const Text("Achromatopsia Theme"),
                  onPressed: (BuildContext context) {
                    Provider.of<ThemeModel>(context, listen: false)
                        .setAchroTheme();
                    ScaffoldMessenger.of(context).removeCurrentSnackBar();
                    ScaffoldMessenger.of(context)
                        .showSnackBar(FireAuth.customSnackBar(
                      content: 'Achromatopsia Mode Activated!',
                      color: Colors.green,
                    ));
                  }),
            ])
          ],
        ));
  }
}

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
          SettingsSection(title: const Text("Portrait"), tiles: <SettingsTile>[
            SettingsTile(
                title: const Text('1x1'),
                onPressed: (BuildContext context) {
                  setState(() {
                    vertGridSize = 1;
                  });
                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                  ScaffoldMessenger.of(context)
                      .showSnackBar(FireAuth.customSnackBar(
                    content: 'Portrait columns set to 1!',
                    color: Colors.green,
                  ));
                }),
            SettingsTile(
                title: const Text('2x2'),
                onPressed: (BuildContext context) {
                  setState(() {
                    vertGridSize = 2;
                  });
                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                  ScaffoldMessenger.of(context)
                      .showSnackBar(FireAuth.customSnackBar(
                    content: 'Portrait columns set to 2!',
                    color: Colors.green,
                  ));
                }),
            SettingsTile(
                title: const Text('3x3'),
                onPressed: (BuildContext context) {
                  setState(() {
                    vertGridSize = 3;
                  });
                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                  ScaffoldMessenger.of(context)
                      .showSnackBar(FireAuth.customSnackBar(
                    content: 'Portrait columns set to 3!',
                    color: Colors.green,
                  ));
                }),
          ]),
          SettingsSection(title: const Text("Landscape"), tiles: <SettingsTile>[
            SettingsTile(
                title: const Text('1x1'),
                onPressed: (BuildContext context) {
                  setState(() {
                    horiGridSize = 1;
                  });
                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                  ScaffoldMessenger.of(context)
                      .showSnackBar(FireAuth.customSnackBar(
                    content: 'Landscape rows set to 1!',
                    color: Colors.green,
                  ));
                }),
            SettingsTile(
                title: const Text('2x2'),
                onPressed: (BuildContext context) {
                  setState(() {
                    horiGridSize = 2;
                  });
                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                  ScaffoldMessenger.of(context)
                      .showSnackBar(FireAuth.customSnackBar(
                    content: 'Landscape rows set to 2!',
                    color: Colors.green,
                  ));
                }),
            SettingsTile(
              title: const Text('3x3'),
              onPressed: (BuildContext context) {
                setState(() {
                  horiGridSize = 3;
                });
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                ScaffoldMessenger.of(context)
                    .showSnackBar(FireAuth.customSnackBar(
                  content: 'Landscape rows set to 3!',
                  color: Colors.green,
                ));
              },
            ),
          ]),
        ]));
  }
}

class LanguagePage extends StatefulWidget {
  const LanguagePage({Key? key}) : super(key: key);

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Language'),
        ),
        body: SettingsList(sections: [
          SettingsSection(title: const Text('Languages'), tiles: <SettingsTile>[
            SettingsTile.navigation(
              leading: const Icon(Icons.language),
              title: const Text('Spanish'),
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
        ]));
  }
}

//************************************************************** */

class _SettingsPageState extends State<SettingsPage> {
  String? data;
  bool _isLoggedIn = false;
  User? user = FirebaseAuth.instance.currentUser;
  bool _isSigningOut = false;

  void _loadData() async {
    final _loadedData =
        await rootBundle.loadString('assets/privacy_policy.txt');
    setState(() {
      data = _loadedData;
      _checkLoggedIn();
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _checkLoggedIn() {
    if (user != null) {
      setState(() {
        _isLoggedIn = true;
      });
    }
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
                  Navigator.of(context).push(CupertinoPageRoute(
                    builder: (context) => const PasswordResetPage(),
                  ));
                },
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.account_circle),
                trailing: const Icon(Icons.chevron_right),
                title: const Text('Change Email'),
                onPressed: (BuildContext context) {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: ((context) => const EmailResetPage())));
                },
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.logout),
                trailing: const Icon(Icons.chevron_right),
                title: const Text('Logout'),
                onPressed: (BuildContext context) async {
                  if (user != null) {
                    setState(() {
                      _isSigningOut = true;
                    });
                    await FirebaseAuth.instance.signOut();
                    setState(() {
                      _isSigningOut = false;
                    });
                    Navigator.of(context).pushReplacement(
                      CupertinoPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  }
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
                trailing: const Icon(Icons.chevron_right),
                onPressed: (BuildContext context) {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: ((context) => const GridviewPage())));
                },
              ),
              SettingsTile.navigation(
                  leading: const Icon(Icons.water_drop),
                  title: const Text('Themes'),
                  trailing: const Icon(Icons.chevron_right),
                  onPressed: (BuildContext context) {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: ((context) => const ThemePage())));
                  }),
              SettingsTile.navigation(
                  leading: const Icon(Icons.language),
                  title: const Text('Languages'),
                  trailing: const Icon(Icons.chevron_right),
                  onPressed: (BuildContext context) {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: ((context) => const LanguagePage())));
                  })
            ],
          ),
          SettingsSection(
            title: const Text('Legal'),
            tiles: <SettingsTile>[
              SettingsTile(
                  trailing: const Icon(Icons.chevron_right),
                  title: const Text('About'),
                  onPressed: (BuildContext context) {
                    showAboutDialog(
                      context: context,
                      applicationIcon: Image.asset('assets/Aacai_2.png',
                          width: 75, height: 75),
                      applicationName: 'AAC.AI',
                      applicationVersion: '1.0.0',
                      applicationLegalese: '©2023 AAC.AI',
                      children: [
                        const SizedBox(height: 24),
                        const Text(
                            '''AAC.AI is a free and feature-rich AAC (Augmentative Alternative Communication) application that is available on both iOS and Android. 
                        \nThis application is targeted at kids with disabilities that prevent them from verbal communication, including language, speech, child-onset fluency, and social communications disorders. 
                        \nAAC.AI allows the user to communicate with a series of images using a fully customizable imageboard and provides the ability to explore the world around them using Real Time Object Detection powered by YoloV2-Tiny. 
                        \nThis application was created for the flagship Software Engineering project at Sam Houston State University'''),
                        const Divider(color: Colors.black),
                      ],
                    );
                  }),
              SettingsTile(
                trailing: const Icon(Icons.chevron_right),
                title: const Text('Privacy Policy'),
                onPressed: (BuildContext context) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          scrollable: true,
                          content: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(data ?? 'empty'),
                              ],
                            ),
                          ),
                        );
                      });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
