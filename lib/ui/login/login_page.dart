import 'package:aacademic/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../utils/themes.dart';
import 'profile_page.dart';
import 'register_page.dart';
import 'package:aacademic/firebase/fire_auth.dart';
import 'package:aacademic/firebase/validator.dart';
import 'forgot_password_page.dart';
import 'package:aacademic/utils/UI_templates.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _isProcessing = false;
  var _isObscured = true;

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.of(context).pushReplacement(
        CupertinoPageRoute(
          fullscreenDialog: true,
          builder: (context) => const MyHomePage(
            title: 'AAC.AI',
          ),
        ),
      );
    }

    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    MyThemes.lightTheme;

    //  final appleSignInAvailable =
    //     Provider.of<AppleSignInAvailable>(context, listen: false);

    return GestureDetector(
        onTap: () {
          _focusEmail.unfocus();
          _focusPassword.unfocus();
        },
        child: Scaffold(
          //page background color
          backgroundColor: const Color.fromARGB(255, 225, 225, 225),
          //top bar
          appBar: AppBar(
              title: const Text('Welcome'),
              automaticallyImplyLeading: false,
              centerTitle: true,
              titleTextStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40,
                color: Colors.white,
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/settings');
                  },
                ),
              ]),

          body: FutureBuilder(
              future: _initializeFirebase(),
              builder: (context, snapshot) {
                return Padding(
                    //padding for all fields
                    padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          //logo--add image to assets folder and call
                          const Image(
                            image: AssetImage("assets/logos/logo.png"),
                            height: 100,
                            width: 300,
                          ),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                //email textfield
                                TextFormField(
                                  controller: _emailTextController,
                                  focusNode: _focusEmail,
                                  validator: (value) => Validator.validateEmail(
                                    email: value,
                                  ),
                                  decoration: UITemplates.textFieldDeco(
                                      hintText: "Email"),
                                ),
                                const SizedBox(height: 5),
                                //password textfield
                                TextFormField(
                                  controller: _passwordTextController,
                                  focusNode: _focusPassword,
                                  obscureText: _isObscured,
                                  validator: (value) =>
                                      Validator.validatePassword(
                                    password: value,
                                  ),
                                  decoration: InputDecoration(
                                      hintText: "Password",
                                      hintStyle:
                                          const TextStyle(color: Colors.white),
                                      //Icon button toggles password visibility
                                      suffixIcon: IconButton(
                                        padding:
                                            const EdgeInsetsDirectional.only(
                                                end: 12.0),
                                        icon: _isObscured
                                            ? const Icon(Icons.visibility)
                                            : const Icon(Icons.visibility_off),
                                        onPressed: () {
                                          setState(() {
                                            _isObscured = !_isObscured;
                                          });
                                        },
                                      ),
                                      enabledBorder: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white)),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                        borderSide: const BorderSide(
                                          color: Colors.red,
                                        ),
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xff6A145D))),
                                      fillColor: const Color(0xffABC99B),
                                      filled: true),
                                ),
                                const SizedBox(height: 5),
                                //forgot password button
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const ForgotPasswordPage(),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        'Forgot Password?',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 25),
                                _isProcessing
                                    ? const CircularProgressIndicator()
                                    //sign in button
                                    : GestureDetector(
                                        onTap: () async {
                                          _focusEmail.unfocus();
                                          _focusPassword.unfocus();

                                          if (_formKey.currentState!
                                              .validate()) {
                                            setState(() {
                                              _isProcessing = true;
                                            });

                                            User? user = await FireAuth
                                                .signInUsingEmailPassword(
                                              email: _emailTextController.text,
                                              password:
                                                  _passwordTextController.text,
                                              context: context,
                                            );

                                            setState(() {
                                              _isProcessing = false;
                                            });

                                            if (user != null) {
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProfilePage(
                                                    user: user,
                                                  ),
                                                ),
                                              );
                                            }
                                          }
                                        },
                                        child: UITemplates.buttonDeco(
                                            displayText: "Sign in",
                                            vertInset: 24),
                                      ),

                                const SizedBox(height: 15),
                                //or continue with row
                                Row(
                                  children: const [
                                    Expanded(
                                      child: Divider(
                                        thickness: 2,
                                        color: Color(0xff6A145D),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Or continue with',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                    Expanded(
                                      child: Divider(
                                          thickness: 2,
                                          color: Color(0xff6A145D)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                //google sign in button
                                GestureDetector(
                                    onTap: () async {
                                      setState(() {
                                        _isProcessing = true;
                                      });
                                      User? user =
                                          await FireAuth.signInWithGoogle(
                                              context: context);
                                      setState(() {
                                        _isProcessing = false;
                                      });

                                      if (user != null) {
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ProfilePage(
                                              user: user,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    child: UITemplates.squareTile(
                                        imagePath: "assets/logos/google.png")),
                                const SizedBox(height: 30),
                                //register now
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      CupertinoPageRoute(
                                        builder: (context) =>
                                            const RegisterPage(),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text('Dont have an account? '),
                                      Text(
                                        'Register now',
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ]));
              }),
        ));
  }
}
