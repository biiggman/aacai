import 'package:aacademic/firebase/validator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:aacademic/firebase/fire_auth.dart';
import 'package:aacademic/utils/UI_templates.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _registerFormKey = GlobalKey<FormState>();

  final _emailTextController = TextEditingController();

  final _focusEmail = FocusNode();

  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusEmail.unfocus();
      },
      child: Scaffold(
        //page background color
        backgroundColor: const Color.fromARGB(255, 225, 225, 225),
        //top bar
        appBar: AppBar(
            title: Text("forgot_pw_appbar_title".tr()),
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
                  key: _registerFormKey,
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
                            hintText: "forgot_pw_deco_hint".tr()),
                      ),
                      const SizedBox(height: 5),
                      const SizedBox(height: 16.0),
                      _isProcessing
                          ? const CircularProgressIndicator()
                          //reset password button
                          : GestureDetector(
                              onTap: () async {
                                _focusEmail.unfocus();

                                if (_registerFormKey.currentState!.validate()) {
                                  setState(() {
                                    _isProcessing = true;
                                  });

                                  FireAuth.forgotPassword(
                                      email: _emailTextController.text.trim(),
                                      context: context);

                                  setState(() {
                                    _isProcessing = false;
                                  });
                                }
                              },
                              child: UITemplates.buttonDeco(
                                  displayText:
                                      "forgot_pw_button_deco_text".tr(),
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
