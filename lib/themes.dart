import 'package:flutter/material.dart';
import 'package:path/path.dart';

enum MyThemeKeys { LIGHT, DARK, PRO, TRI, ACHROMA }

class MyThemes {
  static const THEME_KEY = "theme_key";

  static final ThemeData lightTheme = ThemeData(
//Standard properties are done up here, before the object declarations.
    primaryColor: const Color(0xff6A145D),
    brightness: Brightness.light,
    highlightColor: Colors.white,

//Alterations to overarching appbar theme are done in this object.
    appBarTheme: const AppBarTheme(
      color: Color(0xff6A145D),
      shape: BeveledRectangleBorder(),
      titleTextStyle: TextStyle(color: Colors.white),
      //toolbarTextStyle:
    ),

//BNB theme properties.
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xff6A145D),
      selectedItemColor: Color(0xff7ca200),
      unselectedItemColor: Colors.white70,
    ),

//Alterations to selected text go here, probably not too useful?
    textSelectionTheme: const TextSelectionThemeData(
      selectionColor: Colors.grey,
      //cursorColor: Color(0xff171d49),
      //selectionHandleColor: Color(0xff4260bd),
    ),

//Text button properties. Text button is often used for forms and fillable fields.
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
      backgroundColor:
          MaterialStateProperty.all<Color>(const Color(0xff6A145D)),

      //If you want white text on buttons globally, change this value
      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
      overlayColor: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.hovered)) {
            return const Color(0xff7ca200);
          }
          if (states.contains(MaterialState.focused) ||
              states.contains(MaterialState.pressed)) {
            return const Color(0xffABC99B);
          }
          return null; // Defer to the widget's default.
        },
      ),
    )),

//Elevated button properties. Standard buttons with drop shadow effect.
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
      backgroundColor:
          MaterialStateProperty.all<Color>(const Color(0xff6A145D)),
      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
      overlayColor: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.hovered)) {
            return const Color(0xff7ca200);
          }
          if (states.contains(MaterialState.focused) ||
              states.contains(MaterialState.pressed)) {
            return const Color(0xffABC99B);
          }
          return null; // Defer to the widget's default.
        },
      ),
    )),

//Standard button theme, applies to buttons not specified within theme class
    buttonTheme: const ButtonThemeData(
        buttonColor: Color(0xff6A145D),
        focusColor: Color(0xff7ca200),
        splashColor: Color(0xffABC99B)),

//floating action button properties, used to hold a buttons position on a page while scrolling.
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xff6A145D),
        focusColor: Color(0xff7ca200),
        splashColor: Color(0xffABC99B)),

//Color scheme properties
    colorScheme: ColorScheme.fromSwatch()
        .copyWith(secondary: Colors.white)
        .copyWith(background: const Color(0xff6A145D)),
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: Colors.grey,
    brightness: Brightness.dark,
    highlightColor: Colors.white,
    scaffoldBackgroundColor: Colors.black54,
    dialogBackgroundColor: Colors.black54,
    textSelectionTheme:
        const TextSelectionThemeData(selectionColor: Colors.grey),
  );

  static final ThemeData protanopiaTheme = ThemeData(
    primaryColor: const Color(0xff4A4940),
    brightness: Brightness.light,
    highlightColor: Colors.white,

//Alterations to overarching appbar theme are done in this object.
    appBarTheme: const AppBarTheme(
      color: Color(0xff4A4940),
      shape: BeveledRectangleBorder(),
      titleTextStyle: TextStyle(color: Colors.black),
      //toolbarTextStyle:
    ),

//BNB theme properties.
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xff4A4940),
      selectedItemColor: Color(0xff8c8c27),
      unselectedItemColor: Colors.white70,
    ),

//Alterations to selected text go here, probably not too useful?
    textSelectionTheme: const TextSelectionThemeData(
      selectionColor: Colors.grey,
      //cursorColor: Color(0xff171d49),
      //selectionHandleColor: Color(0xff4260bd),
    ),

//Text button properties. Text button is often used for forms and fillable fields.
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
      backgroundColor:
          MaterialStateProperty.all<Color>(const Color(0xff4A4940)),
      foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
      overlayColor: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.hovered)) {
            return const Color(0xff8c8c27);
          }
          if (states.contains(MaterialState.focused) ||
              states.contains(MaterialState.pressed)) {
            return const Color(0xff393C09);
          }
          return null; // Defer to the widget's default.
        },
      ),
    )),
  );

  static final ThemeData tritanopiaTheme = ThemeData(
    primaryColor: const Color(0xff553e3e),
    brightness: Brightness.light,
    highlightColor: Colors.white,

    //Alterations to overarching appbar theme are done in this object.
    appBarTheme: const AppBarTheme(
      color: Color(0xff553e3e),
      shape: BeveledRectangleBorder(),
      titleTextStyle: TextStyle(color: Colors.black),
      //toolbarTextStyle:
    ),

    //BNB theme properties.
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xff553e3e),
      selectedItemColor: Color(0xff7d464c),
      unselectedItemColor: Colors.white70,
    ),

    //Alterations to selected text go here, probably not too useful?
    textSelectionTheme: const TextSelectionThemeData(
      selectionColor: Colors.grey,
      //cursorColor: Color(0xff171d49),
      //selectionHandleColor: Color(0xff4260bd),
    ),

    //Text button properties. Text button is often used for forms and fillable fields.
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
      backgroundColor:
          MaterialStateProperty.all<Color>(const Color(0xff553e3e)),
      foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
      overlayColor: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.hovered)) {
            return const Color(0xff7d464c);
          }
          if (states.contains(MaterialState.focused) ||
              states.contains(MaterialState.pressed)) {
            return const Color(0xff391f21);
          }
          return null; // Defer to the widget's default.
        },
      ),
    )),
  );

  static final ThemeData achromatopsiaTheme = ThemeData(
    primaryColor: const Color(0xff434343),
    brightness: Brightness.light,
    highlightColor: Colors.white,

    //Alterations to overarching appbar theme are done in this object.
    appBarTheme: const AppBarTheme(
      color: Color(0xff434343),
      shape: BeveledRectangleBorder(),
      titleTextStyle: TextStyle(color: Colors.black),
      //toolbarTextStyle:
    ),

    //BNB theme properties.
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xff434343),
      selectedItemColor: Color(0xff848484),
      unselectedItemColor: Colors.white70,
    ),

    //Alterations to selected text go here, probably not too useful?
    textSelectionTheme: const TextSelectionThemeData(
      selectionColor: Colors.grey,
      //cursorColor: Color(0xff171d49),
      //selectionHandleColor: Color(0xff4260bd),
    ),

    //Text button properties. Text button is often used for forms and fillable fields.
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
      backgroundColor:
          MaterialStateProperty.all<Color>(const Color(0xff434343)),
      foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
      overlayColor: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.hovered)) {
            return const Color(0xff848484);
          }
          if (states.contains(MaterialState.focused) ||
              states.contains(MaterialState.pressed)) {
            return const Color(0xff353535);
          }
          return null; // Defer to the widget's default.
        },
      ),
    )),
  );

  static ThemeData getThemeFromKey(MyThemeKeys themeKey) {
    switch (themeKey) {
      case MyThemeKeys.LIGHT:
        return lightTheme;
      case MyThemeKeys.DARK:
        return darkTheme;
      case MyThemeKeys.PRO:
        return protanopiaTheme;
      case MyThemeKeys.TRI:
        return tritanopiaTheme;
      case MyThemeKeys.ACHROMA:
        return achromatopsiaTheme;
      default:
        return lightTheme;
    }
  }
}
