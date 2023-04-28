import 'package:flutter/material.dart';

class LanguageController extends ChangeNotifier {
  onLanguageChanged() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    notifyListeners();
  }
}
