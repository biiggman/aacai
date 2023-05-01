import 'dart:io';
import 'package:aacademic/ui/settings/language_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:aacademic/ui/button_menus/delete_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:aacademic/ui/imageboard_ui.dart/custom_appbar.dart';
import 'package:aacademic/camera/camera_page.dart';
import 'package:aacademic/firebase/fire_auth.dart';
import 'package:aacademic/firebase/validator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:aacademic/ui/login/login_page.dart';
import 'package:aacademic/ui/settings/settings_page.dart';
import 'package:aacademic/ui/button_menus/color_button.dart';
import 'package:aacademic/ui/button_menus/preview_button.dart';
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
import 'package:flutter_pw_validator/Resource/Strings.dart';
import 'package:provider/provider.dart';

//current language selected
String currentLanguage = "en-US";

//number of rows when viewing imageboard in landscape mode
int horiGridSize = 2;

//number of columns when viewing imageboard in portrait mode
int vertGridSize = 3;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeModel>(
          create: (context) => ThemeModel(),
        ),
        ChangeNotifierProvider<LanguageController>(
            create: (_) => LanguageController())
      ],
      child: EasyLocalization(
        supportedLocales: const [Locale('en', 'US'), Locale('es', 'ES')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en', 'US'),
        child: const MyApp(),
      )
      /*ChangeNotifierProvider<ThemeModel>(
      create: ((context) => ThemeModel()),
      child: EasyLocalization(
        supportedLocales: const [Locale('en', 'US'), Locale('es', 'ES')],
        path: 'assets/translations/',
        fallbackLocale: const Locale('en', 'US'),
        child: const MyApp(),*/
      ));

  //const MyApp());
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
      theme: Provider.of<ThemeModel>(context).currentTheme,

      //language support here
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
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
  //navigation bar index
  int _selectedIndex = 2;

  //imageboard lists
  late Future<List<RawMaterialButton>> _imageboardRef;
  List<RawMaterialButton> _selectedFolderButtons = [];
  List<RawMaterialButton> _buttons = [];

  //current user
  String uid = FirebaseAuth.instance.currentUser!.uid;

  //button variables
  String buttonName = "";
  String buttonLocation = "";
  Color? buttonColor;
  File? _selectedImage;
  String? _selectedFolder;
  
  //buttonUtils class
  ButtonUtils buttonUtils = ButtonUtils();

  //keys here
  final navKey = GlobalKey();
  final _addButtonKey = GlobalKey<FormState>();
  final _sourceImageKey = GlobalKey();
  final _buttonColorKey = GlobalKey();

  //misc variables
  bool _isProcessing = false;
  bool _isButtonChecked = false;
  bool _isFolderChecked = false;
  bool _loading = false;

  //initial state of AAC.AI
  @override
  void initState() {
    super.initState();
    populateButtons();
  }

  //refreshes color on selection
  void onColorSelected(Color color) {
    setState(() {
      buttonColor = color;
    });
  }

  //refreshes image on selection
  void _onImageSelected(File selectedImage) {
    setState(() {
      _selectedImage = selectedImage;
    });
  }

  //handles pull down to refresh
  Future<void> fetchData() async {
    setState(() {
      _loading = true;
    });

    populateButtons();

    setState(() {
      _loading = false;
    });
  }

  //refresh imageboard after button adds
  Future<void> _refresh() async {
    await fetchData();
  }

  final TextEditingController _textEditingController = TextEditingController();

  //navigation bar logic
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
                      insetPadding: const EdgeInsets.symmetric(horizontal: 10),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 5.0),
                      scrollable: true,
                      title: Text(
                        'main_add_hint'.tr(),
                        textAlign: TextAlign.center,
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
                                                                "main_template_hint"
                                                                    .tr()),
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
                                                              title: Text(
                                                                "main_btnadd_btn"
                                                                    .tr(),
                                                                style:
                                                                    const TextStyle(
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
                                                                  _isFolderChecked =
                                                                      false;
                                                                  _selectedFolder =
                                                                      null;
                                                                  print(
                                                                      'folder: $_isFolderChecked');
                                                                  print(
                                                                      'button: $_isButtonChecked');
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
                                                              title: Text(
                                                                "main_folderadd_btn"
                                                                    .tr(),
                                                                style:
                                                                    const TextStyle(
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
                                                                  _isButtonChecked =
                                                                      false;
                                                                  _selectedImage ==
                                                                      null;
                                                                  print(
                                                                      'folder: $_isFolderChecked');
                                                                  print(
                                                                      'button: $_isButtonChecked');
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ]),
                                                  const SizedBox(height: 10),
                                                  //folder dropdown for adding buttons to specific folder
                                                  Visibility(
                                                    visible: _isButtonChecked,
                                                    child: Column(
                                                      children: [
                                                        StreamBuilder<
                                                                QuerySnapshot<
                                                                    Map<String,
                                                                        dynamic>>>(
                                                            stream:
                                                                imageboardUtils
                                                                    .getFolders(),
                                                            builder: (BuildContext
                                                                    context,
                                                                AsyncSnapshot<
                                                                        QuerySnapshot<
                                                                            Map<String,
                                                                                dynamic>>>
                                                                    snapshot) {
                                                              if (snapshot
                                                                  .hasError) {
                                                                return Text(
                                                                    'Error: {$snapshot.error}');
                                                              }
                                                              if (snapshot
                                                                      .connectionState ==
                                                                  ConnectionState
                                                                      .waiting) {
                                                                return const CircularProgressIndicator();
                                                              }
                                                              List<
                                                                      DropdownMenuItem<
                                                                          String>>
                                                                  dropDownItems =
                                                                  [];
                                                              if (snapshot
                                                                      .data!
                                                                      .docs
                                                                      .length ==
                                                                  1) {
                                                                dropDownItems =
                                                                    [];
                                                              } else {
                                                                for (var folderDoc
                                                                    in snapshot
                                                                        .data!
                                                                        .docs) {
                                                                  Map<String,
                                                                          dynamic>
                                                                      data =
                                                                      folderDoc
                                                                          .data();
                                                                  if (data.containsKey(
                                                                      'folder_name')) {
                                                                    String
                                                                        folderName =
                                                                        folderDoc[
                                                                            'folder_name'];
                                                                    dropDownItems
                                                                        .add(
                                                                            DropdownMenuItem(
                                                                      value:
                                                                          folderName,
                                                                      child: Text(
                                                                          folderName),
                                                                    ));
                                                                  }
                                                                }
                                                              }
                                                              return DropdownButtonFormField(
                                                                  decoration: UITemplates.textFieldDeco(
                                                                      hintText:
                                                                          'main_select_fodler'
                                                                              .tr()),
                                                                  value:
                                                                      _selectedFolder,
                                                                  items:
                                                                      dropDownItems,
                                                                  onChanged:
                                                                      (String?
                                                                          newValue) {
                                                                    setState(
                                                                        () {
                                                                      _selectedFolder =
                                                                          newValue;
                                                                    });
                                                                  });
                                                            }),
                                                        const SizedBox(
                                                            height: 10),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  //camera roll button for selecting images for buttons
                                                  Visibility(
                                                    visible: _isButtonChecked,
                                                    child: Column(
                                                      children: [
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
                                                          child: buttonDeco(
                                                              displayText:
                                                                  "main_camera_img_src"
                                                                      .tr(),
                                                              vertInset: 10),
                                                        ),
                                                        const SizedBox(
                                                            height: 10),
                                                      ],
                                                    ),
                                                  ),
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
                                                            //if for adding button
                                                            if (_isButtonChecked ==
                                                                true) {
                                                              if (buttonColor == null ||
                                                                  _selectedImage ==
                                                                      null ||
                                                                  buttonName ==
                                                                      "") {
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                        FireAuth
                                                                            .customSnackBar(
                                                                  content:
                                                                      'main_button_add_false'
                                                                          .tr(),
                                                                  color: Colors
                                                                      .red,
                                                                ));
                                                              } else {
                                                                print(
                                                                    _isFolderChecked);
                                                                print(
                                                                    _selectedImage);
                                                                imageboardUtils.uploadImage(
                                                                    buttonName,
                                                                    buttonColor!,
                                                                    _isFolderChecked,
                                                                    _selectedFolder);
                                                                Navigator.pop(
                                                                    context);
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                        FireAuth
                                                                            .customSnackBar(
                                                                  content:
                                                                      'main_button_add_true'
                                                                          .tr(),
                                                                  color: Colors
                                                                      .green,
                                                                ));
                                                              }
                                                            }
                                                            //else if for adding folder
                                                            else if (_isFolderChecked ==
                                                                true) {
                                                              if (buttonColor ==
                                                                      null ||
                                                                  buttonName ==
                                                                      "") {
                                                                print(
                                                                    'ADDED FOLDER');

                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                        FireAuth
                                                                            .customSnackBar(
                                                                  content:
                                                                      'main_button_add_false'
                                                                          .tr(),
                                                                  color: Colors
                                                                      .red,
                                                                ));
                                                              } else {
                                                                imageboardUtils.uploadImage(
                                                                    buttonName,
                                                                    buttonColor!,
                                                                    _isFolderChecked,
                                                                    null);
                                                                Navigator.pop(
                                                                    context);
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                        FireAuth
                                                                            .customSnackBar(
                                                                  content:
                                                                      'main_folder_add_true'
                                                                          .tr(),
                                                                  color: Colors
                                                                      .green,
                                                                ));
                                                              }
                                                            }
                                                          },
                                                          child: buttonDeco(
                                                              displayText:
                                                                  'main_add_btn'
                                                                      .tr(),
                                                              vertInset: 10),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      //cancel button
                                                      Expanded(
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);
                                                            _isButtonChecked =
                                                                false;
                                                            _isFolderChecked =
                                                                false;
                                                          },
                                                          child: buttonDeco(
                                                              displayText:
                                                                  'main_cancel_btn'
                                                                      .tr(),
                                                              vertInset: 10),
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
              _isButtonChecked = false;
              _isFolderChecked = false;
            });
          });
        }
        break;

      case 1:
        {
          showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              builder: (BuildContext context) {
                return SingleChildScrollView(
                    child: Container(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  height: 70 + MediaQuery.of(context).viewInsets.bottom,
                  color: Colors.white60,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          controller: _textEditingController,
                          minLines: null,
                          maxLines: null,
                          autocorrect: true,
                          expands: true,
                          decoration: InputDecoration(
                              hintText: 'main_tts_hint'.tr(),
                              hintStyle: const TextStyle(color: Colors.white),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xff6A145D))),
                              fillColor: const Color(0xffABC99B),
                              filled: true),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            TextToSpeech.speak(_textEditingController.text);
                            _textEditingController.clear();
                          },
                          icon: const Icon(Icons.send_rounded)),
                    ],
                  ),
                ));
              }).then((_) {
            _textEditingController.clear();
          });
        }
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

  //create button parameters
  RawMaterialButton createButton(String name, String location, Color color,
      bool inFolder, String DocID, String folderID) {
    RawMaterialButton button = RawMaterialButton(
      key: Key(name),
      onPressed: () {
        setState(() {
          buttonUtils.addButtonToList(name, location, color);
          TextToSpeech.speak(name);
        });
      },
      onLongPress: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return DeleteMenu(
                isFolder: inFolder,
                id: DocID,
                folderID: folderID,
              );
            });
      },
      elevation: 2.0,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: color, width: 2),
          borderRadius: BorderRadius.circular(18)),
      padding: const EdgeInsets.all(3.0),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Expanded(
          child: CachedNetworkImage(
            imageUrl: location,
            height: 100,
            width: 100,
            fit: BoxFit.contain,
          ),
        ),
        Column(
          children: [
            Text(
              name,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        )
      ]),
    );
    return button;
  }

  RawMaterialButton createFolder(
      String name,
      Color color,
      String folderId,
      Map<String, List<RawMaterialButton>> folderButtonsMap,
      Function(List<RawMaterialButton>) onFolderSelect) {
    const folderIcon = Icon(Icons.folder, size: 48);
    RawMaterialButton button = RawMaterialButton(
      onPressed: () {
        print(folderId);
        List<RawMaterialButton>? folderButtons = folderButtonsMap[folderId];
        print(folderButtons);
        onFolderSelect(folderButtons ?? []);
        TextToSpeech.speak(name);
      },
      onLongPress: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return DeleteMenu(isFolder: true, folderID: folderId);
            });
      },
      elevation: 2.0,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: color, width: 2),
          borderRadius: BorderRadius.circular(18)),
      padding: const EdgeInsets.all(3.0),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Expanded(
          child: folderIcon,
        ),
        Column(
          children: [
            Text(
              name,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        )
      ]),
    );
    return button;
  }

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
      bool inFolder = false;

      RawMaterialButton imageButton = createButton(buttonName, buttonLocation,
          buttonColor, inFolder = false, doc.id, "");
      buttons.add(imageButton);
    }

    //Iterate through each Folder in the UserID collection
    QuerySnapshot<Map<String, dynamic>> folderRef = await FirebaseFirestore
        .instance
        .collection('user-information')
        .doc(uid)
        .collection('folders')
        .orderBy('folder_color', descending: true)
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

      RawMaterialButton folderButton = createFolder(
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
          .orderBy('image_color', descending: true)
          .get();

      for (var imageDoc in imageRef.docs) {
        //create a RawMaterialBUtton for the buttons within a folder
        if (imageDoc.id == 'initial') {
          continue;
        }
        int colorValue = imageDoc['image_color'];
        String buttonName = imageDoc['image_name'];
        String buttonLocation = imageDoc['image_location'];
        Color buttonColor = Color(colorValue);
        bool isFolder = false;

        RawMaterialButton imageButton = createButton(buttonName, buttonLocation,
            buttonColor, isFolder, imageDoc.id, folderDoc.id);
        folderButtons.add(imageButton);
      }

      folderButtonsMap[folderDoc.id] = folderButtons;

      buttons.add(folderButton);
    }

    //sorts the entire list by colors. this allows users to define what the colors mean to them.
    buttons.sort((a, b) {
      int aColorValue = (a.shape as RoundedRectangleBorder).side.color.value;
      int bColorValue = (b.shape as RoundedRectangleBorder).side.color.value;

      return aColorValue.compareTo(aColorValue);
    });

    setState(() {
      _buttons = buttons;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: OrientationBuilder(builder: ((context, orientation) {
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
                    child: _loading
                        ? const CircularProgressIndicator()
                        : GridView.count(
                            scrollDirection: orientation == Orientation.portrait
                                ? Axis.vertical
                                : Axis.horizontal,
                            crossAxisCount: orientation == Orientation.portrait
                                ? vertGridSize
                                : horiGridSize,
                            crossAxisSpacing:
                                orientation == Orientation.portrait ? 20 : 5,
                            mainAxisSpacing:
                                orientation == Orientation.portrait ? 20 : 5,
                            padding: const EdgeInsets.all(15),
                            children: _selectedFolderButtons.isNotEmpty
                                ? _selectedFolderButtons
                                : _buttons))),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              key: navKey,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: const Icon(Icons.add),
                  label: 'main_add_btn'.tr(),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.keyboard),
                  label: 'navBar_keyboard'.tr(),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.home),
                  label: 'navBar_home'.tr(),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.camera),
                  label: 'navBar_Camera'.tr(),
                ),
                BottomNavigationBarItem(
                    icon: const Icon(Icons.settings),
                    label: 'navBar_Settings'.tr()),
              ],
              onTap: _onItemTapped,
              currentIndex: 2,
            ),
          );
        })));
  }
}
