import 'package:aacademic/camera_page.dart';
import 'package:aacademic/login_page.dart';
import 'package:aacademic/settings_page.dart';
import 'package:aacademic/themes.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  runApp(const MyApp());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //Material App Constructor
      title: 'Flutter Demo',

      initialRoute: '/', //Route logic for navigation

      routes: {
        '/login': (context) => const LoginPage(),
        '/settings': (context) => const SettingsPage(),
      },

      theme: MyThemes.lightTheme,

//CHANGE THIS BACK TO MYHOMEPAGE, USING IT TO TEST LOGIN PAGE
      home: const LoginPage(
          //title: '',
          ),
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
  int _counter = 0;
  int _selectedIndex = 0;

  //dummy variables
  Color colorVariable = Colors.blue;
  String imageURLTest = '';
  String buttonTestTitle = '';

  //keys here
  final navKey = GlobalKey();
  final _addButtonKey = GlobalKey<FormState>();
  final _sourceImageKey = GlobalKey();
  final _buttonColorKey = GlobalKey();

  void _incrementCounter() {
    setState(() {
      _counter++;
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
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  scrollable: true,
                  title: const Text('Add a Button'),
                  content: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Form(
                        key: _addButtonKey,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 4,
                              child: RawMaterialButton(
                                onPressed: () {},
                                elevation: 2.0,
                                constraints: const BoxConstraints(
                                    minHeight: 100, minWidth: 100),
                                fillColor: Colors.green,
                                padding: const EdgeInsets.all(3.0),
                                shape: const CircleBorder(),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.emoji_emotions),
                                    SizedBox(height: 5),
                                    Text('My Button')
                                  ],
                                ),
                              ),
                            ),
                            Flexible(
                                flex: 4,
                                fit: FlexFit.tight,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextFormField(
                                        decoration: const InputDecoration(
                                          labelText: 'Button Name',
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      const Text('Picture: '),
                                      ButtonBar(
                                        key: _sourceImageKey,
                                        alignment: MainAxisAlignment.center,
                                        buttonPadding:
                                            const EdgeInsets.all(10.0),
                                        buttonAlignedDropdown: true,
                                        children: <Widget>[
                                          ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pushNamed('/');
                                              },
                                              child: const Text('Gallery')),
                                          ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pushNamed('/');
                                              },
                                              child: const Text('Camera Roll'))
                                        ],
                                      ),
                                      SizedBox(height: 20),
                                      const Text('Button Color: '),
                                      ButtonBar(
                                        key: _buttonColorKey,
                                        alignment: MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        buttonHeight: 1.5,
                                        buttonMinWidth: 1.5,
                                        buttonPadding:
                                            const EdgeInsets.all(5.0),
                                        buttonAlignedDropdown: true,
                                        children: <Widget>[
                                          RawMaterialButton(
                                            onPressed: () {},
                                            elevation: 2.0,
                                            fillColor: Colors.red,
                                            padding: const EdgeInsets.all(3.0),
                                            shape: const CircleBorder(),
                                          ),
                                          RawMaterialButton(
                                            onPressed: () {},
                                            elevation: 2.0,
                                            fillColor: Colors.orange,
                                            padding: const EdgeInsets.all(3.0),
                                            shape: const CircleBorder(),
                                          ),
                                          RawMaterialButton(
                                            onPressed: () {},
                                            elevation: 2.0,
                                            fillColor: Colors.yellow,
                                            padding: const EdgeInsets.all(3.0),
                                            shape: const CircleBorder(),
                                          ),
                                          RawMaterialButton(
                                            onPressed: () {},
                                            elevation: 2.0,
                                            fillColor: Colors.green,
                                            padding: const EdgeInsets.all(3.0),
                                            shape: const CircleBorder(),
                                          ),
                                          RawMaterialButton(
                                            onPressed: () {},
                                            elevation: 2.0,
                                            fillColor: Colors.blue,
                                            padding: const EdgeInsets.all(3.0),
                                            shape: const CircleBorder(),
                                          ),
                                          RawMaterialButton(
                                            onPressed: () {},
                                            elevation: 2.0,
                                            fillColor: Colors.purple,
                                            padding: const EdgeInsets.all(3.0),
                                            shape: const CircleBorder(),
                                          ),
                                          RawMaterialButton(
                                            onPressed: () {},
                                            elevation: 2.0,
                                            fillColor: Colors.white,
                                            padding: const EdgeInsets.all(3.0),
                                            shape: const CircleBorder(),
                                          ),
                                          RawMaterialButton(
                                            onPressed: () {},
                                            elevation: 2.0,
                                            fillColor: Colors.black,
                                            padding: const EdgeInsets.all(3.0),
                                            shape: const CircleBorder(),
                                          ),
                                          RawMaterialButton(
                                            onPressed: () {},
                                            elevation: 2.0,
                                            fillColor: Colors.grey,
                                            padding: const EdgeInsets.all(3.0),
                                            shape: const CircleBorder(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      )),
                );
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        children: <Widget>[
          RawMaterialButton(
            onPressed: () {},
            constraints: const BoxConstraints(minHeight: 80, minWidth: 80),
            fillColor: Colors.red,
            padding: const EdgeInsets.all(3.0),
            shape: const CircleBorder(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.emoji_emotions),
                SizedBox(height: 5),
                Text('My Button')
              ],
            ),
          ),
          RawMaterialButton(
            onPressed: () {},
            constraints: const BoxConstraints(minHeight: 60, minWidth: 60),
            fillColor: Colors.red,
            padding: const EdgeInsets.all(3.0),
            shape: const CircleBorder(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.emoji_emotions),
                SizedBox(height: 5),
                Text('My Button')
              ],
            ),
          ),
          RawMaterialButton(
            onPressed: () {},
            constraints: const BoxConstraints(minHeight: 60, minWidth: 60),
            fillColor: Colors.blue,
            padding: const EdgeInsets.all(3.0),
            shape: const CircleBorder(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.emoji_emotions),
                SizedBox(height: 5),
                Text('My Button')
              ],
            ),
          ),
          RawMaterialButton(
            onPressed: () {},
            constraints: const BoxConstraints(minHeight: 60, minWidth: 60),
            fillColor: Colors.yellow,
            padding: const EdgeInsets.all(3.0),
            shape: const CircleBorder(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.emoji_emotions),
                SizedBox(height: 5),
                Text('My Button')
              ],
            ),
          ),
          RawMaterialButton(
            onPressed: () {},
            constraints: const BoxConstraints(minHeight: 60, minWidth: 60),
            fillColor: Colors.green,
            padding: const EdgeInsets.all(3.0),
            shape: const CircleBorder(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.emoji_emotions),
                SizedBox(height: 5),
                Text('My Button')
              ],
            ),
          )
        ],
      )),
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
  }
}

class imageboardButton extends RawMaterialButton {
  final String label;
  final String imageUrl;

  const imageboardButton(
      {required this.label, required this.imageUrl, required super.onPressed});
}

class imageboardModel extends ChangeNotifier {
  List<imageboardButton> _buttonList = [];

  List<imageboardButton> get buttonList => _buttonList;

  addImageboardButton(imageboardButton buttonArg) {
    _buttonList.add(buttonArg);
    notifyListeners();
  }
}
