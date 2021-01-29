import 'dart:developer';

import 'package:flutter/material.dart';
import '../services/storage_manager.dart';

class ThemeNotifier with ChangeNotifier {
  final darkTheme = ThemeData(
    fontFamily: 'Roboto',
    primarySwatch: Colors.grey,
    primaryColor: Colors.black,
    brightness: Brightness.dark,
    backgroundColor: const Color(0xFF212121),
    accentColor: Colors.white,
    accentIconTheme: IconThemeData(color: Colors.black),
    dividerColor: Colors.black12,
    primaryTextTheme: TextTheme(
      bodyText1: TextStyle(
        color: Colors.white
      ),
      bodyText2: TextStyle(
        color: Colors.grey[200]
      ),
      headline6: TextStyle(
        color: Colors.white
      )
    ),
    primaryIconTheme: const IconThemeData.fallback().copyWith(
      color: Colors.white,
    ),
    appBarTheme: AppBarTheme(
      brightness: Brightness.dark,
      color: Color(0xFF212121),
    )
  );

  final lightTheme = ThemeData(
    fontFamily: 'Roboto',
    primarySwatch: Colors.grey,
    primaryColor: Colors.white,
    brightness: Brightness.light,
    backgroundColor: const Color(0xFFE5E5E5),
    accentColor: Colors.black,
    accentIconTheme: IconThemeData(color: Colors.white),
    dividerColor: Colors.white54,
    primaryTextTheme: TextTheme(
      bodyText1: TextStyle(
        color: Colors.black
      ),
      bodyText2: TextStyle(
        color: Colors.grey
      ),
      headline6: TextStyle(
        color: Colors.black
      )
    ),
    primaryIconTheme: const IconThemeData.fallback().copyWith(
      color: Colors.black,
    ),
    appBarTheme: AppBarTheme(
      brightness: Brightness.light,
      color: Colors.white,
    )
  );

  ThemeData _themeData;
  ThemeData getTheme() => _themeData ?? lightTheme;
  bool isDarkMode = false;

  ThemeNotifier() {
    StorageManager.read('themeMode').then((value) {
      log('Storage value: ' + value.toString());
      var themeMode = value ?? 'light';
      if (themeMode == 'light') {
        _themeData = lightTheme;
        isDarkMode = false;
      } else {
        log('Changing mode to dark');
        _themeData = darkTheme;
        isDarkMode = true;
      }
      notifyListeners();
    });
  }

  void setDarkMode() async {
    _themeData = darkTheme;
    isDarkMode = true;
    StorageManager.save('themeMode', 'dark');
    notifyListeners();
  }

  void setLightMode() async {
    _themeData = lightTheme;
    isDarkMode = false;
    StorageManager.save('themeMode', 'light');
    notifyListeners();
  }

}