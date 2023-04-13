import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'profile_page.dart';
import '/firebase/fire_auth.dart';
import '/firebase/validator.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _registerFormKey = GlobalKey<FormState>();

  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _focusName = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _isProcessing = false;
  var _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusName.unfocus();
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 225, 225, 225),
        appBar: AppBar(
            backgroundColor: Colors.purple,
            title: const Text('Register'),
            titleTextStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40,
                color: Colors.white)),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Form(
                  key: _registerFormKey,
                  child: Column(
                    children: <Widget>[
                      //name textfield
                      TextFormField(
                        controller: _nameTextController,
                        focusNode: _focusName,
                        validator: (value) => Validator.validateName(
                          name: value,
                        ),
                        decoration: InputDecoration(
                            hintText: "Name",
                            hintStyle: TextStyle(color: Colors.grey[500]),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              borderSide: const BorderSide(
                                color: Colors.red,
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 122, 2, 152))),
                            fillColor: const Color.fromARGB(255, 246, 210, 253),
                            filled: true),
                      ),
                      const SizedBox(height: 16.0),
                      //email textfield
                      TextFormField(
                        controller: _emailTextController,
                        focusNode: _focusEmail,
                        validator: (value) => Validator.validateEmail(
                          email: value,
                        ),
                        decoration: InputDecoration(
                            hintText: "Email",
                            hintStyle: TextStyle(color: Colors.grey[500]),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              borderSide: const BorderSide(
                                color: Colors.red,
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 122, 2, 152))),
                            fillColor: const Color.fromARGB(255, 246, 210, 253),
                            filled: true),
                      ),
                      const SizedBox(height: 16.0),
                      //password textfield
                      TextFormField(
                        controller: _passwordTextController,
                        focusNode: _focusPassword,
                        obscureText: _isObscured,
                        validator: (value) => Validator.validatePassword(
                          password: value,
                        ),
                        decoration: InputDecoration(
                            hintText: "Password",
                            hintStyle: const TextStyle(
                                color: Color.fromARGB(255, 158, 158, 158)),
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
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              borderSide: const BorderSide(
                                color: Colors.red,
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 122, 2, 152))),
                            fillColor: const Color.fromARGB(255, 246, 210, 253),
                            filled: true),
                      ),
                      //password status validator
                      const SizedBox(height: 25),
                      FlutterPwValidator(
                        controller: _passwordTextController,
                        minLength: 6,
                        uppercaseCharCount: 1,
                        numericCharCount: 1,
                        specialCharCount: 1,
                        normalCharCount: 1,
                        width: 400,
                        height: 150,
                        onSuccess: () {
                          return true;
                        },
                        onFail: () {
                          return false;
                        },
                      ),
                      SizedBox(height: 32.0),
                      _isProcessing
                          ? const CircularProgressIndicator()
                          //sign up button
                          : GestureDetector(
                              onTap: () async {
                                if (_registerFormKey.currentState!.validate()) {
                                  setState(() {
                                    _isProcessing = true;
                                  });

                                  User? user =
                                      await FireAuth.registerUsingEmailPassword(
                                    name: _nameTextController.text,
                                    email: _emailTextController.text,
                                    password: _passwordTextController.text,
                                    context: context,
                                  );

                                  setState(() {
                                    _isProcessing = false;
                                  });

                                  if (user != null) {
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ProfilePage(user: user),
                                      ),
                                      ModalRoute.withName('/'),
                                    );
                                  }
                                }
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 24),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: Colors.purple),
                                child: const Center(
                                  child: Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    ],
                  )),
            ]),
          ),
        ),
      ),
    );
  }
}
