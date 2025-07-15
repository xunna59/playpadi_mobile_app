import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.indigo,
  scaffoldBackgroundColor: Colors.white,
  colorScheme: const ColorScheme.light(
    primary: Color.fromRGBO(120, 66, 255, 1),
    onPrimary: Colors.white,
    tertiary: Colors.white,
    secondary: Color(0xF9FAFC),
    onSecondary: Colors.black,
    surface: Colors.grey,
    onSurface: Colors.black,
    primaryContainer: Colors.white,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    elevation: 0,
  ),
  textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.black)),
  snackBarTheme: SnackBarThemeData(backgroundColor: Colors.redAccent),
  cardColor: Colors.white,
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.indigo,
  scaffoldBackgroundColor: Colors.black45,
  colorScheme: const ColorScheme.dark(
    primary: Color.fromRGBO(120, 66, 255, 1),
    onPrimary: Colors.white,
    tertiary: Colors.black45,
    primaryContainer: Colors.black,

    // secondary: Color.fromRGBO(10, 8, 18, 1),
    secondary: Color(0xFF1B1D25),
    onSecondary: Colors.black,
    surface: Colors.grey,
    onSurface: Colors.white,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white)),
  snackBarTheme: SnackBarThemeData(backgroundColor: Colors.redAccent),
  cardColor: Colors.white12,
);
