import 'package:flutter/material.dart';

class CustomAppTheme {
  static ThemeData appTheme() {
    return ThemeData(
      primaryColor: Colors.black,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        color: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        actionsIconTheme: IconThemeData(color: Colors.white),
      ),
      textTheme: const TextTheme(
        bodyText1: TextStyle(color: Colors.black),
        bodyText2: TextStyle(color: Colors.black),
        headline1: TextStyle(color: Colors.black),
        headline2: TextStyle(color: Colors.black),
        caption: TextStyle(color: Colors.black),
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: Colors.black,
        textTheme: ButtonTextTheme.primary,
      ),
      iconTheme: const IconThemeData(color: Colors.black),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
    );
  }
}
