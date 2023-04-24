import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:aacademic/ui/imageboard_ui.dart/custom_appbar.dart';
import 'package:aacademic/camera/camera_page.dart';
import 'package:aacademic/firebase/fire_auth.dart';
import 'package:aacademic/firebase/validator.dart';
import 'package:aacademic/ui/imageboard_ui.dart/custom_appbar.dart';
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

String currentLanguage = "en-US";
int horiGridSize = 2;
int vertGridSize = 3;

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
      home: FutureBuilder(
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
  int _selectedIndex = 2;
  late Future<List<RawMaterialButton>> _imageboardRef;
  List<RawMaterialButton> _selectedFolderButtons = [];
  List<RawMaterialButton> _buttons = [];

  //button variables
  String buttonName = "";
  String buttonLocation = "";
  Color? buttonColor;
  File? _selectedImage;
  ButtonUtils buttonUtils = ButtonUtils();

  //keys here
  final navKey = GlobalKey();
  final _addButtonKey = GlobalKey<FormState>();
  final _sourceImageKey = GlobalKey();
  final _buttonColorKey = GlobalKey();
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    populateButtons();
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
        {
          ImageboardUtils imageboardUtils = ImageboardUtils();
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return Scaffold(
                  backgroundColor: Colors.grey,
                  body: AlertDialog(
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
                                                      const SizedBox(width: 5),
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
            setState(() {
              _selectedImage = null;
            });
          });
        }
        break;

      case 1:
        break;

      case 2:
        setState(() {
          _selectedFolderButtons = [];
        });

        break;

      case 3:
        {
          await availableCameras().then((value) => Navigator.push(context,
              CupertinoPageRoute(builder: (_) => CameraPage(cameras: value))));
        }
        break;

      case 4:
        Navigator.of(context).push(CupertinoPageRoute(
          builder: (context) => const SettingsPage(),
        ));
        break;
    }
  }

  String uid = FirebaseAuth.instance.currentUser!.uid;

  Future<void> populateButtons() async {
    QuerySnapshot<Map<String, dynamic>> imageboardRef = await FirebaseFirestore
        .instance
        .collection('user-information')
        .doc(uid)
        .collection('imageboard')
        .orderBy('image_color', descending: true)
        .get();

    List<RawMaterialButton> buttons = [];

    for (var doc in imageboardRef.docs) {
      if (doc.id == 'initial') {
        continue;
      }

      //data from database
      int colorValue = doc['image_color'];
      String buttonName = doc['image_name'];
      String buttonLocation = doc['image_location'];
      Color buttonColor = Color(colorValue);

      RawMaterialButton imageButton =
          buttonUtils.createButton(buttonName, buttonLocation, buttonColor);
      buttons.add(imageButton);
    }

    //Iterate through each Folder in the UserID collection
    QuerySnapshot<Map<String, dynamic>> folderRef = await FirebaseFirestore
        .instance
        .collection('user-information')
        .doc(uid)
        .collection('folders')
        .get();

    //data map of buttons within a respected folder
    Map<String, List<RawMaterialButton>> folderButtonsMap = {};

    for (var folderDoc in folderRef.docs) {
      if (folderDoc.id == 'initial') {
        continue;
      }

      //Create a RawMaterialButton for the folders

      int colorValue = folderDoc['folder_color'];
      String buttonName = folderDoc['folder_name'];
      Color buttonColor = Color(colorValue);

      RawMaterialButton folderButton = buttonUtils.createFolder(
          buttonName, buttonColor, folderDoc.id, folderButtonsMap, (buttons) {
        setState(() {
          _selectedFolderButtons = buttons;
        });
      });

      //list of buttons in a respected folder
      List<RawMaterialButton> folderButtons = [];

      //Iterate through each document in the current folder
      QuerySnapshot<Map<String, dynamic>> imageRef = await FirebaseFirestore
          .instance
          .collection('user-information')
          .doc(uid)
          .collection('folders')
          .doc(folderDoc.id)
          .collection('images')
          .get();

      for (var imageDoc in imageRef.docs) {
        //create a RawMaterialBUtton for the buttons within a folder

        int colorValue = imageDoc['image_color'];
        String buttonName = imageDoc['image_name'];
        String buttonLocation = imageDoc['image_location'];
        Color buttonColor = Color(colorValue);

        RawMaterialButton imageButton =
            buttonUtils.createButton(buttonName, buttonLocation, buttonColor);
        folderButtons.add(imageButton);
      }

      folderButtonsMap[folderDoc.id] = folderButtons;

      buttons.add(folderButton);
    }
    setState(() {
      _buttons = buttons;
    });
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
            child: RefreshIndicator(
                onRefresh: _refresh,
                child: _buttons.isEmpty
                    ? const CircularProgressIndicator()
                    : GridView.count(
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
                        children: _selectedFolderButtons.isNotEmpty
                            ? _selectedFolderButtons
                                .map((button) => GestureDetector(
                                      onTap: () {
                                        print('ADDING TO LIST');
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
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Center(child: Text("Delete Button?")),
                                                content: const Text("Are you sure you want to delete this item? It will be permanently deleted along with all of its contents."),
                                                actions: <Widget>[
                                                  UITemplates.buttonDeco(
                                                    displayText: 'Accept', 
                                                    vertInset: 10,
                                                  ),
                                                  const SizedBox(height: 10),
                                                  UITemplates.buttonDeco(
                                                    displayText: 'Cancel',
                                                    vertInset: 10,
                                                  ),
                                                ],
                                              );
                                            });
                                      },
                                      child: button,
                                    ))
                                .toList()
                            : _buttons
                                .map((button) => GestureDetector(
                                      onTap: () {
                                        print(button);
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
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Center(child: Text("Delete Button?")),
                                                content: const Text("Are you sure you want to delete this item? It will be permenently deleted along with all of its contents."),
                                                actions: <Widget>[
                                                  GestureDetector(

                                                  ),
                                                  UITemplates.buttonDeco(
                                                    displayText: 'Accept', 
                                                    vertInset: 10,
                                                  ),
                                                  const SizedBox(height: 10),
                                                  UITemplates.buttonDeco(
                                                    displayText: 'Cancel',
                                                    vertInset: 10,
                                                  ),
                                                ],
                                              );
                                            });
                                      },
                                      child: button,
                                    ))
                                .toList(),
                      ))),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          key: navKey,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'Add',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.keyboard),
              label: 'Keyboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera),
              label: 'Camera',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: 'Settings'),
          ],
          onTap: _onItemTapped,
          currentIndex: 2,
        ),
      );
    }));
  }
}
