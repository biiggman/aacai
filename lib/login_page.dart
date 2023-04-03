import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile_page.dart';
import 'register_page.dart';
import 'fire_auth.dart';
import 'validator.dart';
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
        appBar: AppBar(
          title: Text('Welcome'),
        ),
        body: FutureBuilder(
          future: _initializeFirebase(),
          builder: (context, snapshot) {
            //commented this if statement out to fix entire page reloading on
            //visibilty icon toggle on/off for password
            //if (snapshot.connectionState == ConnectionState.done) {

            return Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: Text(
                      'Logo Here',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: _emailTextController,
                          focusNode: _focusEmail,
                          validator: (value) => Validator.validateEmail(
                            email: value,
                          ),
                          decoration: InputDecoration(
                            hintText: "Email",
                            errorBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              borderSide: BorderSide(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 8.0),
                        TextFormField(
                          controller: _passwordTextController,
                          focusNode: _focusPassword,
                          obscureText: _isObscured,
                          validator: (value) => Validator.validatePassword(
                            password: value,
                          ),
                          decoration: InputDecoration(
                            hintText: "Password",
                            //Icon button toggles password visibility
                            suffixIcon: IconButton(
                              padding:
                                  const EdgeInsetsDirectional.only(end: 12.0),
                              icon: _isObscured
                                  ? const Icon(Icons.visibility)
                                  : const Icon(Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  _isObscured = !_isObscured;
                                });
                              },
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              borderSide: BorderSide(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 24.0),
                        _isProcessing
                            ? CircularProgressIndicator()
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  //sign in =>
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        _focusEmail.unfocus();
                                        _focusPassword.unfocus();

                                        if (_formKey.currentState!.validate()) {
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
                                                    ProfilePage(user: user),
                                              ),
                                            );
                                          }
                                        }
                                      },
                                      child: const Text(
                                        'Sign In',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 24.0),
                                ],
                              ),
                        _isProcessing
                            ? CircularProgressIndicator()
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    //google sign in =>
                                    OutlinedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.white),
                                        shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(40),
                                          ),
                                        ),
                                      ),
                                      onPressed: () async {
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
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 10, 0, 10),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const <Widget>[
                                            Image(
                                              image: AssetImage(
                                                  "assets/google_logo.png"),
                                              height: 35.0,
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 10),
                                              child: Text(
                                                'Sign in with Google',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 24.0),
                                  ]),
                        _isProcessing
                            ? CircularProgressIndicator()
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    //register =>
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  RegisterPage(),
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          'Register',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 24.0),
                                    //forgot password =>
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ForgotPasswordPage(),
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          'Forgot Password',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 24.0),
                                  ]),
                      ],
                    ),
                  )
                ],
              ),
            );
            //} curly brace for if snapshot.connectionstate

            // return Center(
            //   child: CircularProgressIndicator(),
            // );
          },
        ),
      ),
    );
  }
}
