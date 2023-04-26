import 'package:flutter/material.dart';

class UITemplates {
//general textfield decoration
  static InputDecoration textFieldDeco({required String hintText}) {
    return (InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white)),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: const BorderSide(
            color: Colors.red,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xff6A145D))),
        fillColor: const Color(0xffABC99B),
        filled: true));
  }

//general button decoration
  static Container buttonDeco(
      {required String displayText, required double vertInset}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: vertInset),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0), color: Color(0xff6A145D)),
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
