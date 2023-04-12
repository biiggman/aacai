import 'package:aacademic/firebase/validator.dart';
import 'package:flutter/material.dart';
import 'package:aacademic/firebase/fire_auth.dart';

class ForgotPasswordPage extends StatefulWidget {
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
        appBar: AppBar(
          title: Text('Forgot Password'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  key: _registerFormKey,
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
                      SizedBox(height: 16.0),
                      _isProcessing
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: () async {
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
                              child: Text(
                                'Reset Password',
                                style: TextStyle(color: Colors.white),
                              ),
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
