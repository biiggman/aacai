import 'package:aacademic/ui/imageboard_ui.dart/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

enum ThemeType { LIGHT, DARK, PRO, TRI, ACHROMA }

class MyThemes {
  static const THEME_KEY = "theme_key";

//Text theme declarations, passed depending on the overall brightness of the theme
  static const TextTheme darkTextTheme = TextTheme(
      labelLarge: TextStyle(color: Colors.white),
      labelSmall: TextStyle(color: Colors.white));

  static const TextTheme lightTextTheme = TextTheme(
      labelLarge: TextStyle(color: Colors.black),
      labelSmall: TextStyle(color: Colors.black));

  static final ThemeData lightTheme = ThemeData(
//Standard properties are done up here, before the object declarations.
      primaryColor: const Color(0xff6A145D),
      brightness: Brightness.light,
      highlightColor: Colors.white,
      textTheme: lightTextTheme,

//Alterations to overarching appbar theme are done in this object.
      appBarTheme: const AppBarTheme(
        color: Color(0xff6A145D),
        shape: BeveledRectangleBorder(),
        titleTextStyle: TextStyle(color: Colors.white),
        //toolbarTextStyle:
      ),
//changes to dialog boxes.
      dialogTheme: const DialogTheme(
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Color(0xff6A145D),
        ),
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
      colorScheme:
          ColorScheme.fromSwatch().copyWith(secondary: Colors.white).copyWith(
                background: const Color.fromARGB(255, 225, 225, 225),
              ),
      inputDecorationTheme: const InputDecorationTheme(
          hintStyle: TextStyle(color: Colors.white),
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
            ),
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xff6A145D))),
          fillColor: Color(0xffABC99B),
          filled: true),
      dividerTheme:
          const DividerThemeData(thickness: 2, color: Color(0xff6A145D)));

  static final ThemeData darkTheme = ThemeData(
    primaryColor: Colors.grey,
    primaryColorDark: Colors.black,
    primaryColorLight: Colors.white,
    brightness: Brightness.dark,
    highlightColor: Colors.white,
    scaffoldBackgroundColor: Colors.black54,
    dialogBackgroundColor: Colors.black54,
    textSelectionTheme:
        const TextSelectionThemeData(selectionColor: Colors.grey),
    textTheme: darkTextTheme,

    //changes to dialog boxes.
    dialogTheme: const DialogTheme(
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Colors.white,
      ),
    ),
  );

  static final ThemeData protanopiaTheme = ThemeData(
      primaryColor: const Color(0xff4A4940),
      brightness: Brightness.light,
      highlightColor: Colors.white,
      textTheme: lightTextTheme,

//Alterations to overarching appbar theme are done in this object.
      appBarTheme: const AppBarTheme(
        color: Color(0xff4A4940),
        shape: BeveledRectangleBorder(),
        titleTextStyle: TextStyle(color: Colors.black),
      ),

      //changes to dialog boxes.
      dialogTheme: const DialogTheme(
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Color(0xff4A4940),
        ),
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
      buttonTheme: const ButtonThemeData(
          buttonColor: Color(0xff4A4940),
          focusColor: Color(0xff8c8c27),
          splashColor: Color(0xff393C09)),

//floating action button properties, used to hold a buttons position on a page while scrolling.
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xff4A4940),
          focusColor: Color(0xff8c8c27),
          splashColor: Color(0xff393C09)),

//Color scheme properties
      colorScheme:
          ColorScheme.fromSwatch().copyWith(secondary: Colors.white).copyWith(
                background: const Color.fromARGB(255, 225, 225, 225),
              ),
      inputDecorationTheme: const InputDecorationTheme(
          hintStyle: TextStyle(color: Colors.white),
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
            ),
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xff4A4940))),
          fillColor: Color(0xff8c8c27),
          filled: true),
      dividerTheme:
          const DividerThemeData(thickness: 2, color: Color(0xff4A4940)));

  static final ThemeData tritanopiaTheme = ThemeData(
      primaryColor: const Color(0xff553e3e),
      brightness: Brightness.light,
      highlightColor: Colors.white,
      textTheme: lightTextTheme,

      //Alterations to overarching appbar theme are done in this object.
      appBarTheme: const AppBarTheme(
        color: Color(0xff553e3e),
        shape: BeveledRectangleBorder(),
        titleTextStyle: TextStyle(color: Colors.black),
        //toolbarTextStyle:
      ),

      //changes to dialog boxes.
      dialogTheme: const DialogTheme(
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Color(0xff553e3e),
        ),
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
      buttonTheme: const ButtonThemeData(
          buttonColor: Color(0xff553e3e),
          focusColor: Color(0xff7d464c),
          splashColor: Color(0xff391f21)),

//floating action button properties, used to hold a buttons position on a page while scrolling.
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xff553e3e),
          focusColor: Color(0xff7d464c),
          splashColor: Color(0xff391f21)),

//Color scheme properties
      colorScheme:
          ColorScheme.fromSwatch().copyWith(secondary: Colors.white).copyWith(
                background: const Color.fromARGB(255, 225, 225, 225),
              ),
      inputDecorationTheme: const InputDecorationTheme(
          hintStyle: TextStyle(color: Colors.white),
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
            ),
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xff553e3e))),
          fillColor: Color(0xff7d464c),
          filled: true),
      dividerTheme:
          const DividerThemeData(thickness: 2, color: Color(0xff553e3e)));

  static final ThemeData achromatopsiaTheme = ThemeData(
      primaryColor: const Color(0xff434343),
      brightness: Brightness.light,
      highlightColor: Colors.white,
      textTheme: lightTextTheme,

      //Alterations to overarching appbar theme are done in this object.
      appBarTheme: const AppBarTheme(
        color: Color(0xff434343),
        shape: BeveledRectangleBorder(),
        titleTextStyle: TextStyle(color: Colors.black),
        //toolbarTextStyle:
      ),

      //changes to dialog boxes.
      dialogTheme: const DialogTheme(
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Color(0xff434343),
        ),
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
      buttonTheme: const ButtonThemeData(
          buttonColor: Color(0xff434343),
          focusColor: Color(0xff848484),
          splashColor: Colors.white70),

//floating action button properties, used to hold a buttons position on a page while scrolling.
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xff434343),
          focusColor: Color(0xff848484),
          splashColor: Colors.white70),

//Color scheme properties
      colorScheme:
          ColorScheme.fromSwatch().copyWith(secondary: Colors.white).copyWith(
                background: const Color.fromARGB(255, 225, 225, 225),
              ),
      inputDecorationTheme: const InputDecorationTheme(
          hintStyle: TextStyle(color: Colors.white),
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
            ),
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xff434343))),
          fillColor: Color(0xff848484),
          filled: true),
      dividerTheme:
          const DividerThemeData(thickness: 2, color: Color(0xff434343)));
}

class ThemeModel extends ChangeNotifier {
  ThemeData currentTheme = MyThemes.lightTheme;
  ThemeType _ThemeType = ThemeType.LIGHT;

  setLightTheme() {
    if (_ThemeType != ThemeType.LIGHT) {
      currentTheme = MyThemes.lightTheme;
      _ThemeType = ThemeType.LIGHT;

      return notifyListeners();
    }
  }

  setDarkTheme() {
    if (_ThemeType != ThemeType.DARK) {
      currentTheme = MyThemes.darkTheme;
      _ThemeType = ThemeType.DARK;

      return notifyListeners();
    }
  }

  setProTheme() {
    if (_ThemeType != ThemeType.PRO) {
      currentTheme = MyThemes.protanopiaTheme;
      _ThemeType = ThemeType.PRO;

      return notifyListeners();
    }
  }

  setTriTheme() {
    if (_ThemeType != ThemeType.TRI) {
      currentTheme = MyThemes.tritanopiaTheme;
      _ThemeType = ThemeType.TRI;

      return notifyListeners();
    }
  }

  setAchroTheme() {
    if (_ThemeType != ThemeType.ACHROMA) {
      currentTheme = MyThemes.achromatopsiaTheme;
      _ThemeType = ThemeType.ACHROMA;

      return notifyListeners();
    }
  }
}
