import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.blue,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.black), // headline1
      displayMedium: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold, color: Colors.black), // headline2
      bodyLarge: TextStyle(fontSize: 16.0, color: Colors.black), // bodyText1
      bodyMedium: TextStyle(fontSize: 14.0, color: Colors.black), // bodyText2
    ),
    appBarTheme: const AppBarTheme(
      color: Colors.blue,
      titleTextStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white), // headline6
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: Colors.blue,
      textTheme: ButtonTextTheme.primary,
    ),
  );
}
