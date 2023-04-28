import 'package:aacademic/firebase/validator.dart';
import 'package:flutter/material.dart';
import 'package:aacademic/firebase/fire_auth.dart';
import 'package:aacademic/utils/UI_templates.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';

class PasswordResetPage extends StatefulWidget {
  const PasswordResetPage({super.key});

  @override
  _PasswordResetPageState createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  final _passwordFormKey = GlobalKey<FormState>();

  final _oldPasswordTextController = TextEditingController();

  final _newPasswordTextController = TextEditingController();

  final _focusOldPassword = FocusNode();

  final _focusNewPassword = FocusNode();

  bool _isProcessing = false;

  var _isOldPasswordObscured = true;

  var _isNewPasswordObscured = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusOldPassword.unfocus();
        _focusNewPassword.unfocus();
      },
      child: Scaffold(
        //page background color
        backgroundColor: const Color.fromARGB(255, 225, 225, 225),
        //top bar
        appBar: AppBar(
            title: const Text('Change Password'),
            titleTextStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white)),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Form(
                  key: _passwordFormKey,
                  child: Column(
                    children: <Widget>[
                      //old password textfield
                      TextFormField(
                        controller: _oldPasswordTextController,
                        focusNode: _focusOldPassword,
                        obscureText: _isOldPasswordObscured,
                        validator: (value) => Validator.validatePassword(
                          password: value,
                        ),
                        decoration: InputDecoration(
                            hintText: "Current Password",
                            hintStyle: const TextStyle(color: Colors.white),
                            //Icon button toggles password visibility
                            suffixIcon: IconButton(
                              padding:
                                  const EdgeInsetsDirectional.only(end: 12.0),
                              icon: _isOldPasswordObscured
                                  ? const Icon(Icons.visibility)
                                  : const Icon(Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  _isOldPasswordObscured =
                                      !_isOldPasswordObscured;
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
                                borderSide:
                                    BorderSide(color: Color(0xff6A145D))),
                            fillColor: const Color(0xffABC99B),
                            filled: true),
                      ),
                      const SizedBox(height: 5),
                      //new password textfield
                      TextFormField(
                        controller: _newPasswordTextController,
                        focusNode: _focusNewPassword,
                        obscureText: _isNewPasswordObscured,
                        validator: (value) => Validator.validatePassword(
                          password: value,
                        ),
                        decoration: InputDecoration(
                            hintText: "New Password",
                            hintStyle: const TextStyle(color: Colors.white),
                            //Icon button toggles password visibility
                            suffixIcon: IconButton(
                              padding:
                                  const EdgeInsetsDirectional.only(end: 12.0),
                              icon: _isNewPasswordObscured
                                  ? const Icon(Icons.visibility)
                                  : const Icon(Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  _isNewPasswordObscured =
                                      !_isNewPasswordObscured;
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
                                borderSide:
                                    BorderSide(color: Color(0xff6A145D))),
                            fillColor: const Color(0xffABC99B),
                            filled: true),
                      ),
                      const SizedBox(height: 16.0),
                      //new password active validator
                      FlutterPwValidator(
                        defaultColor: Colors.red,
                        controller: _newPasswordTextController,
                        minLength: 6,
                        uppercaseCharCount: 1,
                        numericCharCount: 1,
                        specialCharCount: 1,
                        normalCharCount: 1,
                        width: 400,
                        height: 150,
                        onSuccess: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            FireAuth.customSnackBar(
                              content: 'New password meets requirements',
                              color: Colors.green,
                            ),
                          );
                        },
                        onFail: () {
                          return false;
                        },
                      ),
                      const SizedBox(height: 32),
                      _isProcessing
                          ? const CircularProgressIndicator()
                          //change password button
                          : GestureDetector(
                              onTap: () async {
                                _focusOldPassword.unfocus();
                                _focusNewPassword.unfocus();

                                if (_passwordFormKey.currentState!.validate()) {
                                  setState(() {
                                    _isProcessing = true;
                                  });

                                  FireAuth.changePassword(
                                    oldPassword:
                                        _oldPasswordTextController.text.trim(),
                                    newPassword:
                                        _newPasswordTextController.text.trim(),
                                    context: context,
                                  );

                                  setState(() {
                                    _isProcessing = false;
                                  });
                                }
                              },
                              child: UITemplates.buttonDeco(
                                  displayText: "Change Password",
                                  vertInset: 24),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}