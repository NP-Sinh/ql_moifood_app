import 'package:flutter/material.dart';
import 'colors.dart';

/// Light Theme
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  primaryColor: AppColor.orange,
  scaffoldBackgroundColor: AppColor.background,

  appBarTheme: const AppBarTheme(
    backgroundColor: AppColor.white,
    elevation: 1,
    iconTheme: IconThemeData(color: AppColor.black),
    titleTextStyle: TextStyle(
      color: AppColor.black,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
  ),

  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: AppColor.textDark, fontSize: 16),
    bodyMedium: TextStyle(color: AppColor.textDark, fontSize: 14),
    labelLarge: TextStyle(color: AppColor.textLight, fontSize: 12),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColor.white,
    contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColor.orange, width: 1.5),
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColor.orange,
      foregroundColor: AppColor.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    ),
  ),
);

/// Dark Theme
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: true,
  primaryColor: AppColor.orange,
  scaffoldBackgroundColor: const Color(0xFF121212),

  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1E1E1E),
    elevation: 1,
    iconTheme: IconThemeData(color: AppColor.white),
    titleTextStyle: TextStyle(
      color: AppColor.white,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
  ),

  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: AppColor.white, fontSize: 16),
    bodyMedium: TextStyle(color: AppColor.white, fontSize: 14),
    labelLarge: TextStyle(color: Colors.grey, fontSize: 12),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF1E1E1E),
    contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.grey),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColor.orange, width: 1.5),
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColor.orange,
      foregroundColor: AppColor.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    ),
  ),
);
