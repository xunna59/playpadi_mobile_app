import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.indigo,
  scaffoldBackgroundColor: Colors.white,
  colorScheme: const ColorScheme.light(
    primary: Color.fromRGBO(120, 66, 255, 1),
    onPrimary: Colors.white,

    secondary: Colors.orangeAccent,
    onSecondary: Colors.black,
    surface: Colors.grey,
    onSurface: Colors.black,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    elevation: 0,
  ),
  textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.black)),
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.indigo,
  scaffoldBackgroundColor: Colors.black,
  colorScheme: const ColorScheme.dark(
    primary: Color.fromRGBO(120, 66, 255, 1),
    onPrimary: Colors.white,
    secondary: Colors.orangeAccent,
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
);
