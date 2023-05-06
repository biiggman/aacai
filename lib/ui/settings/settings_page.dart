import 'package:aacademic/ui/login/login_page.dart';

import 'package:aacademic/ui/settings/email_reset_page.dart';
import 'package:aacademic/ui/settings/password_reset_page.dart';
import 'package:aacademic/ui/settings/language_controller.dart';
import 'package:easy_localization/easy_localization.dart';
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
          title: Text('settings_themepage_top'.tr()),
        ),
        body: SettingsList(
          sections: [
            SettingsSection(
                title: Text("settings_themepage_header".tr()),
                tiles: <SettingsTile>[
                  SettingsTile(
                      title: Text("settings_themepage_def_theme".tr()),
                      onPressed: (BuildContext context) {
                        Provider.of<ThemeModel>(context, listen: false)
                            .setLightTheme();
                        ScaffoldMessenger.of(context).removeCurrentSnackBar();
                        ScaffoldMessenger.of(context)
                            .showSnackBar(FireAuth.customSnackBar(
                          content: 'settings_themepage_def_theme_active'.tr(),
                          color: Colors.green,
                        ));
                      }),
                  SettingsTile(
                      title: Text("settings_themepage_dark_theme".tr()),
                      onPressed: (BuildContext context) {
                        Provider.of<ThemeModel>(context, listen: false)
                            .setDarkTheme();
                        ScaffoldMessenger.of(context).removeCurrentSnackBar();
                        ScaffoldMessenger.of(context)
                            .showSnackBar(FireAuth.customSnackBar(
                          content: 'settings_themepage_dark_theme_active'.tr(),
                          color: Colors.green,
                        ));
                      }),
                  SettingsTile(
                      title: Text("settings_themepage_pro_theme".tr()),
                      onPressed: (BuildContext context) {
                        Provider.of<ThemeModel>(context, listen: false)
                            .setProTheme();
                        ScaffoldMessenger.of(context).removeCurrentSnackBar();
                        ScaffoldMessenger.of(context)
                            .showSnackBar(FireAuth.customSnackBar(
                          content: 'settings_themepage_pro_theme_active'.tr(),
                          color: Colors.green,
                        ));
                      }),
                  SettingsTile(
                      title: Text("settings_themepage_tri_theme".tr()),
                      onPressed: (BuildContext context) {
                        Provider.of<ThemeModel>(context, listen: false)
                            .setTriTheme();
                        ScaffoldMessenger.of(context).removeCurrentSnackBar();
                        ScaffoldMessenger.of(context)
                            .showSnackBar(FireAuth.customSnackBar(
                          content: 'settings_themepage_tri_theme_active'.tr(),
                          color: Colors.green,
                        ));
                      }),
                  SettingsTile(
                      title: Text("settings_themepage_achro_theme".tr()),
                      onPressed: (BuildContext context) {
                        Provider.of<ThemeModel>(context, listen: false)
                            .setAchroTheme();
                        ScaffoldMessenger.of(context).removeCurrentSnackBar();
                        ScaffoldMessenger.of(context)
                            .showSnackBar(FireAuth.customSnackBar(
                          content: 'settings_themepage_achro_theme_active'.tr(),
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
          title: Text('settings_gridviewpage_top'.tr()),
        ),
        body: SettingsList(sections: [
          SettingsSection(
              title: Text("settings_gridviewpage_portrait_header".tr()),
              tiles: <SettingsTile>[
                SettingsTile(
                    title: const Text('1x1'),
                    onPressed: (BuildContext context) {
                      setState(() {
                        vertGridSize = 1;
                      });
                      ScaffoldMessenger.of(context).removeCurrentSnackBar();
                      ScaffoldMessenger.of(context)
                          .showSnackBar(FireAuth.customSnackBar(
                        content: "settings_gridviewpage_portrait_1x1_true".tr(),
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
                        content: 'settings_gridviewpage_portrait_2x2_true'.tr(),
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
                        content: 'settings_gridviewpage_portrait_3x3_true'.tr(),
                        color: Colors.green,
                      ));
                    }),
              ]),
          SettingsSection(
              title: Text("settings_gridviewpage_landscape_header".tr()),
              tiles: <SettingsTile>[
                SettingsTile(
                    title: const Text('1x1'),
                    onPressed: (BuildContext context) {
                      setState(() {
                        horiGridSize = 1;
                      });
                      ScaffoldMessenger.of(context).removeCurrentSnackBar();
                      ScaffoldMessenger.of(context)
                          .showSnackBar(FireAuth.customSnackBar(
                        content:
                            "settings_gridviewpage_landscape_1x1_true".tr(),
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
                        content:
                            'settings_gridviewpage_landscape_2x2_true'.tr(),
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
                      content: "settings_gridviewpage_landscape_3x3_true".tr(),
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
    LanguageController langCtrlVariable = context.read<LanguageController>();
    context.watch<LanguageController>();
    return Scaffold(
        appBar: AppBar(
          title: Text('settings_languagepage_top'.tr()),
        ),
        body: SettingsList(sections: [
          SettingsSection(
              title: Text('settings_languagepage_header'.tr()),
              tiles: <SettingsTile>[
                SettingsTile.navigation(
                  leading: const Icon(Icons.language),
                  title: Text('settings_languagepage_en_US_btn'.tr()),
                  onPressed: (BuildContext context) {
                    context.setLocale(const Locale('en', 'US'));
                    langCtrlVariable.onLanguageChanged();
                    ScaffoldMessenger.of(context).removeCurrentSnackBar();
                    ScaffoldMessenger.of(context)
                        .showSnackBar(FireAuth.customSnackBar(
                      content: 'settings_languagepage_en_US_true'.tr(),
                      color: Colors.green,
                    ));
                    setState(() {
                      currentLanguage = "en-US";
                    });
                  },
                ),
                SettingsTile.navigation(
                  leading: const Icon(Icons.language),
                  title: Text('settings_languagepage_es_ES_btn'.tr()),
                  onPressed: (BuildContext context) {
                    context.setLocale(const Locale('es', 'ES'));
                    langCtrlVariable.onLanguageChanged();
                    ScaffoldMessenger.of(context).removeCurrentSnackBar();
                    ScaffoldMessenger.of(context)
                        .showSnackBar(FireAuth.customSnackBar(
                      content: 'settings_languagepage_es_ES_true'.tr(),
                      color: Colors.green,
                    ));

                    setState(() {
                      currentLanguage = "es-ES";
                    });
                  },
                )
              ])
        ]));
  }
}

//************************************************************** */
//settings layout
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
    context.watch<LanguageController>();
    return Scaffold(
      appBar: AppBar(
        title: Text('settings_page_top'.tr()),
      ),
      body: SettingsList(
        sections: [
          if (_isLoggedIn)
            SettingsSection(
              title: Text('settings_acct_header'.tr()),
              tiles: <SettingsTile>[
                SettingsTile.navigation(
                  leading: const Icon(Icons.vpn_key),
                  trailing: const Icon(Icons.chevron_right),
                  title: Text('settings_acct_pwreset_nav'.tr()),
                  onPressed: (BuildContext context) {
                    Navigator.of(context).push(CupertinoPageRoute(
                      builder: (context) => const PasswordResetPage(),
                    ));
                  },
                ),
                SettingsTile.navigation(
                  leading: const Icon(Icons.account_circle),
                  trailing: const Icon(Icons.chevron_right),
                  title: Text('settings_acct_emailreset_nav'.tr()),
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
                  title: Text('settings_acct_logout'.tr()),
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
            title: Text('settings_page_top'.tr()),
            tiles: <SettingsTile>[
              SettingsTile(
                leading: const Icon(Icons.apps),
                title: Text('settings_grid_header'.tr()),
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
                  title: Text('settings_theme_header'.tr()),
                  trailing: const Icon(Icons.chevron_right),
                  onPressed: (BuildContext context) {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: ((context) => const ThemePage())));
                  }),
              SettingsTile.navigation(
                  leading: const Icon(Icons.language),
                  title: Text('settings_lang_header'.tr()),
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
            title: Text('settings_legal_header'.tr()),
            tiles: <SettingsTile>[
              SettingsTile(
                  trailing: const Icon(Icons.chevron_right),
                  title: Text('settings_legal_about'.tr()),
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
                        Text('settings_about'.tr()),
                        const Divider(color: Colors.black),
                      ],
                    );
                  }),
              SettingsTile(
                trailing: const Icon(Icons.chevron_right),
                title: Text('Settings_legal_priv_pol'.tr()),
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
