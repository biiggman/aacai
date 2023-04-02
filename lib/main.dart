import 'dart:io';
import 'package:aacademic/camera/camera_page.dart';
import 'package:aacademic/ui/login_page.dart';
import 'package:aacademic/ui/settings_page.dart';
import 'package:aacademic/utils/add_menu/color_button.dart';
import 'package:aacademic/utils/add_menu/preview_button.dart';
import 'package:aacademic/utils/themes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:aacademic/firebase/firebase_options.dart';
import 'package:aacademic/utils/imageboard_utils.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

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
        home: const LoginPage()

        //ROUTE FOR HOMEPAGE THAT CHECKS FOR LOGIN. NEEDS ROUTE TO ACCOUNT IN SETTINGS TO AVOID SOFTLOCK OUT OF LOGIN PAGE
        //FutureBuilder(
        //future: FirebaseAuth.instance.authStateChanges().first,
        //builder: (context, AsyncSnapshot<User?> snapshot) {
        //  if (snapshot.connectionState == ConnectionState.waiting) {
        //    return const CircularProgressIndicator();
        //  } else if (snapshot.hasData) {
        //    return const MyHomePage(
        //      title: 'AAC.AI',
        //    );
        //  } else {
        //    return const LoginPage();
        //  }
        //}),
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

  void _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        break;

      case 1:
        break;

      case 2:
        {
          ImageboardUtils imageboardUtils = ImageboardUtils();
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    scrollable: true,
                    title: const Text('Add a Button'),
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
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                TextFormField(
                                                  decoration:
                                                      const InputDecoration(
                                                    labelText: 'Button Name',
                                                  ),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      buttonName = value;
                                                    });
                                                  },
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return "Please enter a name.";
                                                    }
                                                    return null;
                                                  },
                                                ),
                                                const SizedBox(height: 10),
                                                const Text('Picture: '),
                                                ButtonBar(
                                                  key: _sourceImageKey,
                                                  alignment:
                                                      MainAxisAlignment.center,
                                                  buttonPadding:
                                                      const EdgeInsets.all(5),
                                                  buttonAlignedDropdown: true,
                                                  children: <Widget>[
                                                    ElevatedButton(
                                                        onPressed: () {
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
                                                        child: const Text(
                                                            'Camera Roll'))
                                                  ],
                                                ),
                                                const Text('Size: '),
                                                ButtonBar(
                                                  alignment:
                                                      MainAxisAlignment.center,
                                                  buttonPadding:
                                                      const EdgeInsets.all(5),
                                                  buttonAlignedDropdown: true,
                                                  children: <Widget>[
                                                    ElevatedButton(
                                                        onPressed: () {
                                                          buttonSize = "1";
                                                        },
                                                        child: const Text(
                                                            'Small: 1x1')),
                                                    ElevatedButton(
                                                        onPressed: () {
                                                          buttonSize = "2";
                                                        },
                                                        child: const Text(
                                                            'Large: 2x2')),
                                                  ],
                                                ),
                                                const SizedBox(height: 10),
                                                Center(
                                                  child: ButtonBar(
                                                    key: _buttonColorKey,
                                                    alignment: MainAxisAlignment
                                                        .center,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    buttonHeight: .5,
                                                    buttonMinWidth: .5,
                                                    buttonPadding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    buttonAlignedDropdown: true,
                                                    children: [
                                                      ColorButton(
                                                          color: buttonColor ??
                                                              Colors
                                                                  .transparent,
                                                          onColorSelected:
                                                              onColorSelected)
                                                    ],
                                                  ),
                                                ),
                                                const Divider(
                                                  thickness: 0.5,
                                                  color: Colors.black,
                                                ),
                                                ButtonBar(
                                                  alignment:
                                                      MainAxisAlignment.center,
                                                  buttonPadding:
                                                      const EdgeInsets.all(5),
                                                  buttonAlignedDropdown: true,
                                                  children: <Widget>[
                                                    _selectedImage != null
                                                        ? PreviewButton(
                                                            previewColor:
                                                                buttonColor ??
                                                                    Colors.red,
                                                            selectedImage:
                                                                _selectedImage,
                                                          )
                                                        : const SizedBox(),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        imageboardUtils
                                                            .uploadImage(
                                                                buttonName,
                                                                buttonSize,
                                                                buttonColor!);
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text('Add'),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            );
                                          },
                                        ))),
                              ],
                            ))));
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
    return OrientationBuilder(
      builder: ((context, orientation) {
        return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        toolbarHeight: orientation == Orientation.portrait ? 100 : 80,
      ),
      body: Center(
        child: FutureBuilder(
            future: buttonUtils.makeButtons(),
            builder: (BuildContext context,
                AsyncSnapshot<List<RawMaterialButton>> imageboardRef) {
              if (imageboardRef.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (imageboardRef.hasError) {
                return Text('Error: ${imageboardRef.error}');
              } else {
                return GridView.count(
                  scrollDirection: orientation == Orientation.portrait
                    ? Axis.vertical
                    : Axis.horizontal,
                  crossAxisCount: 3,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  padding: const EdgeInsets.all(15),
                  children: imageboardRef.data!,
                );
              }
            }),
      ),
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
