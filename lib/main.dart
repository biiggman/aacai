import 'dart:io';
import 'package:aacademic/camera/camera_page.dart';
import 'package:aacademic/firebase/fire_auth.dart';
import 'package:aacademic/firebase/validator.dart';
import 'package:aacademic/ui/custom_appbar.dart';
import 'package:aacademic/ui/login/login_page.dart';
import 'package:aacademic/ui/settings/settings_page.dart';
import 'package:aacademic/ui/add_menu/color_button.dart';
import 'package:aacademic/ui/add_menu/preview_button.dart';
import 'package:aacademic/utils/UI_templates.dart';
import 'package:aacademic/utils/themes.dart';
import 'package:aacademic/utils/tts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:aacademic/firebase/firebase_options.dart';
import 'package:aacademic/utils/imageboard_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //Material App Constructor
      title: 'AAC.AI',
      initialRoute: '/', //Route logic for navigation

      routes: {
        '/login': (context) => const LoginPage(),
        '/settings': (context) => const SettingsPage(),
      },
      theme: MyThemes.lightTheme,
      home: //const LoginPage()

          //ROUTE FOR HOMEPAGE THAT CHECKS FOR LOGIN. NEEDS ROUTE TO ACCOUNT IN SETTINGS TO AVOID SOFTLOCK OUT OF LOGIN PAGE
          FutureBuilder(
              future: FirebaseAuth.instance.authStateChanges().first,
              builder: (context, AsyncSnapshot<User?> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasData) {
                  return const MyHomePage(
                    title: 'AAC.AI',
                  );
                } else {
                  return const LoginPage();
                }
              }),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  late Future<List<RawMaterialButton>> _imageboardRef;

  //button variables
  String buttonName = "";
  String buttonSize = "";
  Color? buttonColor;
  File? _selectedImage;
  ButtonUtils buttonUtils = ButtonUtils();

  //keys here
  final navKey = GlobalKey();
  final _addButtonKey = GlobalKey<FormState>();
  final _sourceImageKey = GlobalKey();
  final _buttonColorKey = GlobalKey();
  bool _isProcessing = false;
  bool _isButtonChecked = false;
  bool _isFolderChecked = false;

  @override
  void initState() {
    super.initState();
    _imageboardRef = buttonUtils.makeButtons();
  }

  void onColorSelected(Color color) {
    setState(() {
      buttonColor = color;
    });
  }

  void _onImageSelected(File selectedImage) {
    setState(() {
      _selectedImage = selectedImage;
    });
  }

//refresh imageboard after button adds
  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 1));
    initState();
    setState(() {});
  }

  void _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        //tappedButtons.add(test);
        break;

      case 1:
        break;

      case 2:
        {
          ImageboardUtils imageboardUtils = ImageboardUtils();
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return Scaffold(
                  backgroundColor: Colors.grey,
                  body: AlertDialog(
                      insetPadding: const EdgeInsets.symmetric(horizontal: 10),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 5.0),
                      scrollable: true,
                      title: const Text(
                        'Add a New Button',
                        textAlign: TextAlign.center,
                      ),
                      titleTextStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color(0xff6A145D),
                      ),
                      content: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Form(
                              key: _addButtonKey,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Flexible(
                                      flex: 4,
                                      fit: FlexFit.tight,
                                      child: Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: StatefulBuilder(
                                            builder: (BuildContext context,
                                                StateSetter setState) {
                                              return Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  //button name textfield
                                                  TextFormField(
                                                    onChanged: (value) {
                                                      setState(() {
                                                        buttonName = value;
                                                      });
                                                    },
                                                    validator: (value) =>
                                                        Validator.validateName(
                                                      name: value,
                                                    ),
                                                    decoration: UITemplates
                                                        .textFieldDeco(
                                                            hintText:
                                                                "Button Name"),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  //button or folder checkbox row
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        //add a button checkbox
                                                        Expanded(
                                                          child:
                                                              GestureDetector(
                                                            child:
                                                                CheckboxListTile(
                                                              dense: true,
                                                              controlAffinity:
                                                                  ListTileControlAffinity
                                                                      .leading,
                                                              title: const Text(
                                                                "Button",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                              tileColor: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                              activeColor:
                                                                  const Color(
                                                                      0xff7ca200),
                                                              side: const BorderSide(
                                                                  color: Colors
                                                                      .white,
                                                                  width: 1.5),
                                                              checkboxShape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              4.0)),
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0)),
                                                              value:
                                                                  _isButtonChecked,
                                                              onChanged: (bool?
                                                                  value) {
                                                                setState(() {
                                                                  _isButtonChecked =
                                                                      value!;
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        //add a folder checkbox
                                                        Expanded(
                                                          child:
                                                              GestureDetector(
                                                            child:
                                                                CheckboxListTile(
                                                              dense: true,
                                                              controlAffinity:
                                                                  ListTileControlAffinity
                                                                      .leading,
                                                              title: const Text(
                                                                "Folder",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                              tileColor: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                              activeColor:
                                                                  const Color(
                                                                      0xff7ca200),
                                                              side: const BorderSide(
                                                                  color: Colors
                                                                      .white,
                                                                  width: 1.5),
                                                              checkboxShape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              4.0)),
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0)),
                                                              value:
                                                                  _isFolderChecked,
                                                              onChanged: (bool?
                                                                  value) {
                                                                setState(() {
                                                                  _isFolderChecked =
                                                                      value!;
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ]),
                                                  const SizedBox(height: 10),
                                                  //folder dropdown for adding buttons to specific folder
                                                  // DropdownButtonFormField(
                                                  //     decoration: UITemplates
                                                  //         .textFieldDeco(
                                                  //             hintText:
                                                  //                 "Folder"),
                                                  //     value: null,
                                                  //     onChanged: null,
                                                  //     items: null),
                                                  // const SizedBox(height: 10),
                                                  //camera roll button
                                                  GestureDetector(
                                                    onTap: () {
                                                      imageboardUtils
                                                          .chooseImage()
                                                          .then(
                                                              (selectedImage) {
                                                        setState(() {
                                                          _onImageSelected(
                                                              selectedImage!);
                                                        });
                                                      });
                                                    },
                                                    child:
                                                        UITemplates.buttonDeco(
                                                            displayText:
                                                                "Camera Roll",
                                                            vertInset: 10),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  //select color button
                                                  GestureDetector(
                                                      key: _buttonColorKey,
                                                      child: ColorButton(
                                                          color: buttonColor ??
                                                              Colors
                                                                  .transparent,
                                                          onColorSelected:
                                                              onColorSelected)),
                                                  //divider bar
                                                  const Divider(
                                                    thickness: 0.5,
                                                    color: Colors.black,
                                                  ),
                                                  _selectedImage != null
                                                      ? PreviewButton(
                                                          previewColor:
                                                              buttonColor ??
                                                                  Colors.grey,
                                                          selectedImage:
                                                              _selectedImage,
                                                        )
                                                      : const SizedBox(),
                                                  const SizedBox(height: 10),
                                                  //add or cancel button row
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      //add button
                                                      Expanded(
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            if (_addButtonKey
                                                                .currentState!
                                                                .validate()) {
                                                              setState(() {
                                                                _isProcessing =
                                                                    true;
                                                              });
                                                            }

                                                            if (buttonColor ==
                                                                    null ||
                                                                _selectedImage ==
                                                                    null ||
                                                                buttonName ==
                                                                    "") {
                                                              ScaffoldMessenger
                                                                      .of(
                                                                          context)
                                                                  .showSnackBar(
                                                                      FireAuth
                                                                          .customSnackBar(
                                                                content:
                                                                    'Please finish making selections',
                                                                color:
                                                                    Colors.red,
                                                              ));
                                                            }

                                                            imageboardUtils
                                                                .uploadImage(
                                                                    buttonName,
                                                                    buttonColor!);
                                                            Navigator.pop(
                                                                context);
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    FireAuth
                                                                        .customSnackBar(
                                                              content:
                                                                  'Button added! Pull down to refresh',
                                                              color:
                                                                  Colors.green,
                                                            ));
                                                          },
                                                          child: UITemplates
                                                              .buttonDeco(
                                                                  displayText:
                                                                      'Add',
                                                                  vertInset:
                                                                      10),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      //cancel button
                                                      Expanded(
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: UITemplates
                                                              .buttonDeco(
                                                                  displayText:
                                                                      'Cancel',
                                                                  vertInset:
                                                                      10),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              );
                                            },
                                          ))),
                                ],
                              )))),
                );
              }).then((_) {
            _selectedImage = null;
          });
        }
        break;

      case 3:
        {
          await availableCameras().then((value) => Navigator.push(context,
              MaterialPageRoute(builder: (_) => CameraPage(cameras: value))));
        }
        break;

      case 4:
        Navigator.of(context).pushNamed('/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: ((context, orientation) {
      return Scaffold(
        //top bar for image stringing
        appBar: CustomAppBar(
          height: 70,
          buttons: buttonUtils.tappedButtons,
          buttonsName: buttonUtils.tappedButtonNames,
        ),
        //imageboard
        body: Center(
          //pull down refresh
          child: RefreshIndicator(
            onRefresh: _refresh,
            child: FutureBuilder(
                future: _imageboardRef,
                builder: (BuildContext context,
                    AsyncSnapshot<List<RawMaterialButton>> imageboardRef) {
                  if (imageboardRef.connectionState ==
                      ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (imageboardRef.hasError) {
                    return Text('Error: ${imageboardRef.error}');
                  } else {
                    return GridView.count(
                      scrollDirection: orientation == Orientation.portrait
                          ? Axis.vertical
                          : Axis.horizontal,
                      crossAxisCount:
                          orientation == Orientation.portrait ? 3 : 2,
                      crossAxisSpacing:
                          orientation == Orientation.portrait ? 20 : 5,
                      mainAxisSpacing:
                          orientation == Orientation.portrait ? 20 : 5,
                      padding: const EdgeInsets.all(15),
                      children: imageboardRef.data!
                          .map((button) => GestureDetector(
                                onTap: () {
                                  print("ADDING TO LIST");
                                  setState(() {
                                    buttonUtils.addButtonToList(button);
                                    TextToSpeech.speak(button.key
                                        .toString()
                                        .replaceAll('<', '')
                                        .replaceAll('>', '')
                                        .replaceAll("'", ''));
                                  });
                                },
                                onLongPress: () {
                                  print("LONG PRESS");
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return const AlertDialog();
                                      });
                                },
                                child: button,
                              ))
                          .toList(),
                    );
                  }
                }),
          ),
        ),
        //bottom navigation bar
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          key: navKey,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Menu',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.keyboard),
              label: 'Keyboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'Add',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera),
              label: 'Camera',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: 'Settings'),
          ],
          onTap: _onItemTapped,
        ),
      );
    }));
  }
}
