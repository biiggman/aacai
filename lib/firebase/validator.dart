import 'package:easy_localization/easy_localization.dart';

class Validator {
  static String? validateName({required String? name}) {
    if (name == null) {
      return null;
    }

    if (name.isEmpty) {
      return 'validator_nameEmp'.tr();
    }

    return null;
  }

  static String? validateEmail({required String? email}) {
    if (email == null) {
      return null;
    }

    RegExp emailRegExp = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

    if (email.isEmpty) {
      return 'validator_emailEmp'.tr();
    } else if (!emailRegExp.hasMatch(email)) {
      return 'validator_validEmail'.tr();
    }

    return null;
  }

  static String? validatePassword({required String? password}) {
    if (password == null) {
      return null;
    }

    //input validation for password
    if (password.isEmpty) {
      return 'validator_pwEmpty'.tr();
    } else if (password.length < 6) {
      return 'validator_pwSix'.tr();
    } else if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return 'validator_pwUpper'.tr();
    } else if (!RegExp(r'[a-z]').hasMatch(password)) {
      return 'validator_pwLower'.tr();
    } else if (!RegExp(r'\d').hasMatch(password)) {
      return 'validator_pwNumber'.tr();
    } else if (!RegExp(r'[!@#\$%\^&\*\(\)]').hasMatch(password)) {
      return 'validator_pwSpecial'.tr();
    }

    return null;
  }
}
