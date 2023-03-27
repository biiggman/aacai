class Validator {
  static String? validateName({required String? name}) {
    if (name == null) {
      return null;
    }

    if (name.isEmpty) {
      return 'Name can\'t be empty';
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
      return 'Email can\'t be empty';
    } else if (!emailRegExp.hasMatch(email)) {
      return 'Enter a valid email';
    }

    return null;
  }

  static String? validatePassword({required String? password}) {
  if (password == null) {
    return null;
  }

  if (password.isEmpty) {
    return 'Password can\'t be empty';
  } else if (password.length < 6) {
    return 'Enter a password of at least 6 characters';
  } else if (!RegExp(r'[A-Z]').hasMatch(password)) {
    return 'Password must contain at least one uppercase letter';
  } else if (!RegExp(r'[a-z]').hasMatch(password)) {
    return 'Password must contain at least one lowercase letter';
  } else if (!RegExp(r'\d').hasMatch(password)) {
    return 'Password must contain at least one number';
  } else if (!RegExp(r'[!@#\$%\^&\*\(\)]').hasMatch(password)) {
    return 'Password must contain at least one special character';
  }

  return null;
}
}
