import 'package:aacademic/camera/camera_page.dart';
import 'package:aacademic/ui/login_page.dart';
import 'package:aacademic/ui/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:aacademic/firebase/firebase_options.dart';
import 'package:aacademic/utils/upload_image.dart';
import 'package:aacademic/tts.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() async {
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
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

      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        title: 'AACademic Demo',
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
  int _selectedIndex = 0;
  final navKey = GlobalKey();

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
          await availableCameras().then((value) => Navigator.push(context,
              MaterialPageRoute(builder: (_) => CameraPage(cameras: value))));
        }
        break;

      case 3:
        Navigator.of(context).pushNamed('/settings');
        break;
    }
  }

  String buttonName = "TEST";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pushNamed('/login');
              },
              child: const Text('Login Page'),
            ),
            ElevatedButton(
                child: Text(buttonName),
                onPressed: () async {
                  TextToSpeech.speak(buttonName);
                })
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        key: navKey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Imageboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: 'Camera',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800], //color options
        onTap: _onItemTapped,
      ),
    );
  }
}
