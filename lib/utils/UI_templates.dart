import 'package:flutter/material.dart';

class UITemplates {
//general textfield decoration
  static InputDecoration textFieldDeco({required String hintText}) {
    return (InputDecoration(
        hintText: hintText,
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
            borderSide: BorderSide(color: Color.fromARGB(255, 122, 2, 152))),
        fillColor: const Color.fromARGB(255, 246, 210, 253),
        filled: true));
  }

//general button decoration
  static Container buttonDeco(
      {required String displayText, required double vertInset}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: vertInset),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0), color: Colors.purple),
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
