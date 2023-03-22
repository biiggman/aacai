import 'package:flutter/material.dart';
import 'package:path/path.dart';

enum MyThemeKeys { LIGHT, DARK }

class MyThemes {
  static final ThemeData lightTheme = ThemeData(
//Standard properties are done up here, before the object declarations.
    primaryColor: const Color(0xffffcc33),
    brightness: Brightness.light,
    highlightColor: Colors.white,

//Alterations to overarching appbar theme are done in this object.
    appBarTheme: const AppBarTheme(
      color: Color(0xffffcc33),
      shape: BeveledRectangleBorder(),
      titleTextStyle: TextStyle(color: Colors.black),
      //toolbarTextStyle:
    ),

//BNB theme properties.
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.black54,
      selectedItemColor: Color(0xffffcc33),
      unselectedItemColor: Colors.white70,
    ),

//Alterations to selected text go here, probably not too useful?
    textSelectionTheme: const TextSelectionThemeData(
      selectionColor: Colors.grey,
      cursorColor: Color(0xff171d49),
      selectionHandleColor: Color(0xff4260bd),
    ),

//Text button properties. Text button is often used for forms and fillable fields.
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
      backgroundColor:
          MaterialStateProperty.all<Color>(const Color(0xffffe69d)),
      foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
      overlayColor: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.hovered)) {
            return const Color(0xffb4c7ff);
          }
          if (states.contains(MaterialState.focused) ||
              states.contains(MaterialState.pressed)) {
            return const Color(0xff4260bd);
          }
          return null; // Defer to the widget's default.
        },
      ),
    )),

//Elevated button properties. Standard buttons with drop shadow effect.
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
      backgroundColor:
          MaterialStateProperty.all<Color>(const Color(0xffffe69d)),
      foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
      overlayColor: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.hovered)) {
            return const Color(0xffb4c7ff);
          }
          if (states.contains(MaterialState.focused) ||
              states.contains(MaterialState.pressed)) {
            return const Color(0xff4260bd);
          }
          return null; // Defer to the widget's default.
        },
      ),
    )),

//Standard button theme, applies to buttons not specified within theme class
    buttonTheme: const ButtonThemeData(
        buttonColor: Color(0xffffcc33),
        focusColor: Color(0xffb4c7ff),
        splashColor: Color(0xffffe69d)),

//floating action button properties, used to hold a buttons position on a page while scrolling.
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xffffcc33),
        focusColor: Color(0xffb4c7ff),
        splashColor: Color(0xffffe69d)),

//Color scheme properties
    colorScheme: ColorScheme.fromSwatch()
        .copyWith(secondary: Colors.white)
        .copyWith(background: const Color(0xffffe69d)),
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: Colors.grey,
    brightness: Brightness.dark,
    highlightColor: Colors.white,
    backgroundColor: Colors.black54,
    textSelectionTheme:
        const TextSelectionThemeData(selectionColor: Colors.grey),
  );

  static ThemeData getThemeFromKey(MyThemeKeys themeKey) {
    switch (themeKey) {
      case MyThemeKeys.LIGHT:
        return lightTheme;
      case MyThemeKeys.DARK:
        return darkTheme;
      default:
        return lightTheme;
    }
  }
}
