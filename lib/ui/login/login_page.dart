import 'package:aacademic/main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../utils/themes.dart';
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
    //  final appleSignInAvailable =
    //     Provider.of<AppleSignInAvailable>(context, listen: false);

    return WillPopScope(
        onWillPop: () async => false,
        child: GestureDetector(
            onTap: () {
              _focusEmail.unfocus();
              _focusPassword.unfocus();
            },
            child: Scaffold(
              //top bar
              appBar: AppBar(
                  title: Text('login_welcome_header'.tr()),
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
                                      validator: (value) =>
                                          Validator.validateEmail(
                                        email: value,
                                      ),
                                      decoration: InputDecoration(
                                          hintText: "login_email_hinttext".tr(),
                                          enabledBorder:
                                              const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white)),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(6.0),
                                            borderSide: const BorderSide(
                                              color: Colors.red,
                                            ),
                                          ),
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
                                          hintText:
                                              "login_password_hinttext".tr(),
                                          //Icon button toggles password visibility
                                          suffixIcon: IconButton(
                                            padding: const EdgeInsetsDirectional
                                                .only(end: 12.0),
                                            icon: _isObscured
                                                ? const Icon(Icons.visibility)
                                                : const Icon(
                                                    Icons.visibility_off),
                                            onPressed: () {
                                              setState(() {
                                                _isObscured = !_isObscured;
                                              });
                                            },
                                          ),
                                          enabledBorder:
                                              const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white)),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(6.0),
                                            borderSide: const BorderSide(
                                              color: Colors.red,
                                            ),
                                          ),
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
                                          child: Text(
                                            'login_forgot_pw'.tr(),
                                            style: const TextStyle(
                                                color: Colors.grey),
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
                                                  email:
                                                      _emailTextController.text,
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
                                                          const MyHomePage(
                                                        title: 'AAC.AI',
                                                      ),
                                                    ),
                                                  );
                                                }
                                              }
                                            },
                                            child: buttonDeco(
                                                displayText:
                                                    "login_signin_prompt".tr(),
                                                vertInset: 24),
                                          ),

                                    const SizedBox(height: 15),
                                    //or continue with row
                                    Row(
                                      children: [
                                        const Expanded(
                                          child: Divider(),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'login_continue_prompt'.tr(),
                                            style: const TextStyle(
                                                color: Colors.grey),
                                          ),
                                        ),
                                        const Expanded(
                                          child: Divider(),
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
                                            Navigator.of(context)
                                                .pushReplacement(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const MyHomePage(
                                                  title: 'AAC.AI',
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                        child: UITemplates.squareTile(
                                            imagePath:
                                                "assets/logos/google.png")),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text('login_noacc_prompt'.tr()),
                                          Text(
                                            'login_register_prompt'.tr(),
                                            style: const TextStyle(
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
            )));
  }
}
