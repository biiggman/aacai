import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/Resource/Strings.dart';

class UITemplates {
//general textfield decoration
  static InputDecoration textFieldDeco({required String hintText}) {
    return (InputDecoration(
        hintText: hintText,
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white)),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: const BorderSide(
            color: Colors.red,
          ),
        )));
  }

  //square tile decoration for google login button
  static Container squareTile({required String imagePath}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
        ),
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[200],
      ),
      child: Image.asset(
        imagePath,
        height: 40,
      ),
    );
  }

  //add checkbox deco here
}

//custom strings class for pw validator
class customStrings implements FlutterPwValidatorStrings {
  @override
  final String atLeast = 'register_pwChecker_sixChar'.tr();
  @override
  final String normalLetters = 'regiser_pwChecker_lower'.tr();
  @override
  final String uppercaseLetters = 'regiser_pwChecker_upper'.tr();
  @override
  final String numericCharacters = 'regiser_pwChecker_number'.tr();
  @override
  final String specialCharacters = 'regiser_pwChecker_special'.tr();
}

class buttonDeco extends StatelessWidget {
  const buttonDeco(
      {super.key, required this.displayText, required this.vertInset});

  final String displayText;
  final double vertInset;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: vertInset),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Theme.of(context).primaryColor),
      child: Center(
        child: Text(
          displayText,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
