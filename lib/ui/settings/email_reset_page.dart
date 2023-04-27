import 'package:aacademic/firebase/validator.dart';
import 'package:flutter/material.dart';
import 'package:aacademic/firebase/fire_auth.dart';
import 'package:aacademic/utils/UI_templates.dart';

class EmailResetPage extends StatefulWidget {
  const EmailResetPage({super.key});

  @override
  _EmailResetPageState createState() => _EmailResetPageState();
}

class _EmailResetPageState extends State<EmailResetPage> {
  final _emailFormKey = GlobalKey<FormState>();

  final _oldEmailTextController = TextEditingController();

  final _newEmailTextController = TextEditingController();

  final _focusNewEmail = FocusNode();

  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusNewEmail.unfocus();
      },
      child: Scaffold(
        //page background color
        backgroundColor: const Color.fromARGB(255, 225, 225, 225),
        //top bar
        appBar: AppBar(
            title: const Text('Change Email'),
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
                  key: _emailFormKey,
                  child: Column(
                    children: <Widget>[
                      //new email textfield
                      TextFormField(
                        controller: _newEmailTextController,
                        focusNode: _focusNewEmail,
                        validator: (value) => Validator.validateEmail(
                          email: value,
                        ),
                        decoration:
                            UITemplates.textFieldDeco(hintText: "New Email"),
                      ),
                      const SizedBox(height: 32),
                      _isProcessing
                          ? const CircularProgressIndicator()
                          //change email button
                          : GestureDetector(
                              onTap: () async {
                                _focusNewEmail.unfocus();

                                if (_emailFormKey.currentState!.validate()) {
                                  setState(() {
                                    _isProcessing = true;
                                  });

                                  FireAuth.changeEmail(
                                      newEmail:
                                          _newEmailTextController.text.trim(),
                                      context: context);

                                  setState(() {
                                    _isProcessing = false;
                                  });
                                }
                              },
                              child: UITemplates.buttonDeco(
                                  displayText: "Change Email", vertInset: 24),
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
