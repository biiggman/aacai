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
            backgroundColor: Colors.purple,
            title: const Text('Forgot Password'),
            titleTextStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white)),
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
                      const SizedBox(height: 5),
                      const SizedBox(height: 16.0),
                      _isProcessing
                          ? const CircularProgressIndicator()
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
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 24),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: Colors.purple),
                                child: const Center(
                                  child: Text(
                                    'Reset Password',
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
