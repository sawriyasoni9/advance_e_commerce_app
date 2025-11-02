import 'package:flutter/material.dart';

sealed class ThemeState {
  ThemeMode get themeMode => ThemeMode.light;
  ThemeData get lightTheme => _lightTheme;
  ThemeData get darkTheme => _darkTheme;
  
  // Light Theme
  static final ThemeData _lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
      centerTitle: true,
    ),
    cardColor: Colors.white,
    dividerColor: Colors.grey[300],
  );

  // Dark Theme
  static final ThemeData _darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: Colors.grey[900],
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[900],
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    cardColor: Colors.grey[800],
    dividerColor: Colors.grey[700],
  );
}

final class ThemeLightState extends ThemeState {
  @override
  ThemeMode get themeMode => ThemeMode.light;
}

final class ThemeDarkState extends ThemeState {
  @override
  ThemeMode get themeMode => ThemeMode.dark;
}

