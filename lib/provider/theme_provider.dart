import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;

  ThemeProvider() {
    _toggleStatusBar();
  }

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggleTheme(bool setDark) {
    themeMode = setDark ? ThemeMode.dark : ThemeMode.light;
    _toggleStatusBar();
    notifyListeners();
  }

  void _toggleStatusBar() {
    Future.delayed(Duration(milliseconds: 1)).then((value) => {
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            statusBarBrightness:
                isDarkMode ? Brightness.light : Brightness.dark,
          ))
        });
  }
}

class MyThemes {
  static final _mainTheme = ThemeData(
    textTheme: TextTheme(
      headline1: GoogleFonts.roboto(fontSize: 60, fontWeight: FontWeight.w800),
      headline2: GoogleFonts.roboto(fontSize: 50, fontWeight: FontWeight.w800),
      headline3: GoogleFonts.roboto(fontSize: 40, fontWeight: FontWeight.w800),
      headline4: GoogleFonts.roboto(fontSize: 30, fontWeight: FontWeight.w800),
      headline5: GoogleFonts.roboto(fontSize: 24, fontWeight: FontWeight.w500),
      headline6: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.w500),
      subtitle1: GoogleFonts.roboto(fontWeight: FontWeight.w600, fontSize: 18),
      subtitle2: GoogleFonts.roboto(fontWeight: FontWeight.w600, fontSize: 15),
      bodyText1: GoogleFonts.roboto(fontSize: 20),
      bodyText2: GoogleFonts.roboto(fontSize: 18),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all<double>(0),
        textStyle: MaterialStateProperty.all<TextStyle>(
          TextStyle(
            fontSize: 18,
          ),
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        padding: MaterialStateProperty.all<EdgeInsets>(
          EdgeInsets.symmetric(vertical: 18, horizontal: 10),
        ),
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled))
              return Color.fromRGBO(87, 173, 239, 1);
            return null; // Use the component's default.
          },
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.transparent,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        borderSide: BorderSide(
          color: Color.fromRGBO(57, 160, 237, 1),
        ),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 18,
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        borderSide: BorderSide(
          color: Colors.transparent,
        ),
      ),
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.transparent,
    ),
  );

  static final darkTheme = _mainTheme.copyWith(
    scaffoldBackgroundColor: Colors.black,
    textTheme: _mainTheme.textTheme.copyWith(
      headline1: _mainTheme.textTheme.headline1.copyWith(color: Colors.white70),
      headline2: _mainTheme.textTheme.headline2.copyWith(color: Colors.white70),
      headline3: _mainTheme.textTheme.headline3.copyWith(color: Colors.white70),
      headline4: _mainTheme.textTheme.headline4.copyWith(color: Colors.white70),
      headline5: _mainTheme.textTheme.headline5.copyWith(color: Colors.white70),
      headline6: _mainTheme.textTheme.headline6.copyWith(color: Colors.white70),
      subtitle1: _mainTheme.textTheme.subtitle1.copyWith(color: Colors.white38),
      subtitle2: _mainTheme.textTheme.subtitle2.copyWith(color: Colors.white38),
      bodyText1: _mainTheme.textTheme.bodyText1.copyWith(color: Colors.white70),
      bodyText2: _mainTheme.textTheme.bodyText2.copyWith(color: Colors.white70),
    ),
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      background: Colors.white,
      error: Colors.red,
      primary: Color.fromRGBO(57, 160, 237, 1),
      primaryVariant: Color.fromRGBO(76, 96, 133, 1),
      secondary: Color.fromRGBO(57, 160, 237, 1),
      secondaryVariant: Color.fromRGBO(76, 96, 133, 1),
      surface: Color.fromRGBO(50, 50, 44, 1),
      onBackground: Colors.black87,
      onError: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
    ),
    appBarTheme: _mainTheme.appBarTheme.copyWith(
      brightness: Brightness.dark,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    inputDecorationTheme: _mainTheme.inputDecorationTheme.copyWith(
      fillColor: Colors.grey[900],
      hintStyle: TextStyle(
        color: Colors.white30,
      ),
      focusColor: Colors.orange,
    ),
  );

  static final lightTheme = _mainTheme.copyWith(
    scaffoldBackgroundColor: Colors.white,
    textTheme: _mainTheme.textTheme.copyWith(
      headline1: _mainTheme.textTheme.headline1.copyWith(color: Colors.black87),
      headline2: _mainTheme.textTheme.headline2.copyWith(color: Colors.black87),
      headline3: _mainTheme.textTheme.headline3.copyWith(color: Colors.black87),
      headline4: _mainTheme.textTheme.headline4.copyWith(color: Colors.black87),
      headline5: _mainTheme.textTheme.headline5.copyWith(color: Colors.black87),
      headline6: _mainTheme.textTheme.headline6.copyWith(color: Colors.black87),
      subtitle1: _mainTheme.textTheme.subtitle1.copyWith(color: Colors.black45),
      subtitle2: _mainTheme.textTheme.subtitle2.copyWith(color: Colors.black45),
      bodyText1: _mainTheme.textTheme.bodyText1.copyWith(color: Colors.black87),
      bodyText2: _mainTheme.textTheme.bodyText2.copyWith(color: Colors.black87),
    ),
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      background: Colors.white,
      error: Colors.red,
      primary: Color.fromRGBO(57, 160, 237, 1),
      primaryVariant: Color.fromRGBO(76, 96, 133, 1),
      secondary: Color.fromRGBO(57, 160, 237, 1),
      secondaryVariant: Color.fromRGBO(76, 96, 133, 1),
      surface: Color.fromRGBO(50, 50, 44, 1),
      onBackground: Colors.black87,
      onError: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.black87,
    ),
    appBarTheme: _mainTheme.appBarTheme.copyWith(
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.black87)),
    inputDecorationTheme: _mainTheme.inputDecorationTheme.copyWith(
      fillColor: Color.fromRGBO(245, 245, 245, 1),
      hintStyle: TextStyle(
        color: Colors.black38,
      ),
    ),
  );
}
