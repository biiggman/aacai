import 'package:aacademic/firebase/validator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/easy_localization.dart';
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
        //top bar
        appBar: AppBar(
            title: Text('email_rstpage_title'.tr()),
            titleTextStyle:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
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
                        decoration: UITemplates.textFieldDeco(
                            hintText: "email_rstpage_newval_hint".tr()),
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
                              child: buttonDeco(
                                  displayText: "email_rstpage_title".tr(),
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
