import 'package:aacademic/firebase/validator.dart';
import 'package:flutter/material.dart';
import 'package:aacademic/firebase/fire_auth.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});


  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _registerFormKey = GlobalKey<FormState>();

  final _emailTextController = TextEditingController();

  final _focusEmail = FocusNode();

  final bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusEmail.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Forgot Password'),
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
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      _isProcessing
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: () {
                                FireAuth.forgotPassword(
                                    email: _emailTextController.text);
                              },
                              child: const Text(
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
