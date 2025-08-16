import 'package:flutter/material.dart';
import 'package:innerspace_booking_app/core/color_constant.dart';

class AppTheme {
    static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: background,
      primaryColor: buttonBackground,
      colorScheme:  ColorScheme.light(
        primary: primaryColor,
        secondary: secondary,
      ),
      iconTheme: IconThemeData(color: iconGrey),
    );
  }
  // static ThemeData lightTheme = ThemeData(
  //   primarySwatch: Colors.blue,
  //   scaffoldBackgroundColor: Colors.white,
  //   appBarTheme: const AppBarTheme(
  //     backgroundColor: Colors.white,
  //     elevation: 0,
  //     iconTheme: IconThemeData(color: Colors.black),
  //     titleTextStyle: TextStyle(
  //       color: Colors.black,
  //       fontSize: 20,
  //       fontWeight: FontWeight.bold,
  //     ),
  //   ),
  //   textTheme: const TextTheme(
  //     displayLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //     displayMedium: TextStyle(fontSize: 16),
  //     displaySmall: TextStyle(fontSize: 14),
  //   ),
  // );
}