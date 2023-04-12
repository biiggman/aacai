import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile_page.dart';
import 'register_page.dart';
import 'package:aacademic/firebase/fire_auth.dart';
import 'package:aacademic/firebase/validator.dart';
import 'forgot_password_page.dart';

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
        MaterialPageRoute(
          builder: (context) => ProfilePage(
            user: user,
          ),
        ),
      );
    }

    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          _focusEmail.unfocus();
          _focusPassword.unfocus();
        },
        child: Scaffold(
          //page background color
          backgroundColor: const Color.fromARGB(255, 225, 225, 225),
          appBar: AppBar(
              title: const Text('Welcome'),
              titleTextStyle:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 40)),

          body: FutureBuilder(
              future: _initializeFirebase(),
              builder: (context, snapshot) {
                //commented this if statement out to fix entire page reloading on
                //visibilty icon toggle on/off for password
                //if (snapshot.connectionState == ConnectionState.done) {

                return Padding(
                    //padding for all fields
                    padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //logo--add image to assets folder and call
                          const Image(
                            image: AssetImage("assets/berrywithbeer.png"),
                            height: 150,
                            width: 150,
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
                                  decoration: InputDecoration(
                                      hintText: "Email",
                                      hintStyle:
                                          TextStyle(color: Colors.grey[500]),
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
                                              color: Color.fromARGB(
                                                  255, 122, 2, 152))),
                                      fillColor: const Color.fromARGB(
                                          255, 246, 210, 253),
                                      filled: true),
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
                                      hintStyle: TextStyle(
                                          color: Color.fromARGB(
                                              255, 158, 158, 158)),
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
                                              color: Color.fromARGB(
                                                  255, 122, 2, 152))),
                                      fillColor: const Color.fromARGB(
                                          255, 246, 210, 253),
                                      filled: true),
                                ),
                                //forgot password button
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    MaterialButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ForgotPasswordPage(),
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
                                _isProcessing
                                    ? const CircularProgressIndicator()
                                    //sign in button
                                    : Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                _focusEmail.unfocus();
                                                _focusPassword.unfocus();

                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  setState(() {
                                                    _isProcessing = true;
                                                  });

                                                  User? user = await FireAuth
                                                      .signInUsingEmailPassword(
                                                    email: _emailTextController
                                                        .text,
                                                    password:
                                                        _passwordTextController
                                                            .text,
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
                                                                user: user),
                                                      ),
                                                    );
                                                  }
                                                }
                                              },
                                              child: const Text(
                                                'Sign In',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                const SizedBox(height: 5),
                                //or continue with row
                                Row(
                                  children: const [
                                    Expanded(
                                      child: Divider(
                                        thickness: 1,
                                        color: Colors.purple,
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
                                        thickness: 1,
                                        color: Colors.purple,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                //google sign in button
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
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
                                              builder: (context) => ProfilePage(
                                                user: user,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.white,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          color: Colors.grey[200],
                                        ),
                                        child: const Image(
                                          image: AssetImage(
                                              "assets/google_logo.png"),
                                          height: 40,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 30),
                                //register now
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => RegisterPage(),
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
    //} curly brace for if snapshot.connectionstate
  }
}
