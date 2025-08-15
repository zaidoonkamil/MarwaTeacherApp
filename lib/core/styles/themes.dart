import 'package:flutter/material.dart';

const Color primaryColor= Color(0XFF64B5F6);
const Color backgroundColor= Colors.white;

class ThemeService {
  final lightTheme = ThemeData(
    scaffoldBackgroundColor:  backgroundColor,
    primaryColor: primaryColor,
    fontFamily: 'Cairo',
    brightness: Brightness.light,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: primaryColor,
        showUnselectedLabels: false
    ),
    buttonTheme: const ButtonThemeData(
        colorScheme: ColorScheme.dark(),
        buttonColor: Colors.black87
    ),
    tabBarTheme: TabBarTheme(
      labelColor: Colors.black87,
      dividerColor: primaryColor,
    ),
    textTheme: TextTheme(
      bodyMedium: TextStyle(
        color: Colors.black
      )
    )
  );
}