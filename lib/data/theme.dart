import 'package:flutter/material.dart';

// Vibrant primary colors
final Color primaryColor = Color(0xFF6A3DE8); // Vibrant purple
final Color accentColor = Color(0xFFFF3D71); // Bright pink
final Color secondaryColor = Color(0xFF2CE69B); // Bright teal

// Light theme colors
final Color lightBgColor = Color(0xFFF9F9FC);
final Color lightCardColor = Colors.white;
final Color lightTextColor = Color(0xFF333333);

// Dark theme colors
final Color darkBgColor = Color(0xFF222B45);
final Color darkCardColor = Color(0xFF2E3A59);
final Color darkTextColor = Colors.white;

final ThemeData appThemeLight = ThemeData(
  primaryColor: primaryColor,
  colorScheme: ColorScheme.light(
    primary: primaryColor,
    secondary: accentColor,
    tertiary: secondaryColor,
  ),
  scaffoldBackgroundColor: lightBgColor,
  cardColor: lightCardColor,
  textTheme: TextTheme(
    headlineMedium: TextStyle(color: lightTextColor, fontWeight: FontWeight.bold),
    titleLarge: TextStyle(color: lightTextColor, fontWeight: FontWeight.w600),
    bodyLarge: TextStyle(color: lightTextColor),
    bodyMedium: TextStyle(color: lightTextColor.withOpacity(0.8)),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: accentColor,
    foregroundColor: Colors.white,
    elevation: 4,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
  ),
  cardTheme: CardTheme(
    elevation: 3,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    shadowColor: primaryColor.withOpacity(0.3),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: lightCardColor,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: primaryColor, width: 2),
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  ),
);

final ThemeData appThemeDark = ThemeData(
  primaryColor: primaryColor,
  colorScheme: ColorScheme.dark(
    primary: primaryColor,
    secondary: accentColor,
    tertiary: secondaryColor,
    surface: darkCardColor,
    background: darkBgColor,
  ),
  scaffoldBackgroundColor: darkBgColor,
  cardColor: darkCardColor,
  textTheme: TextTheme(
    headlineMedium: TextStyle(color: darkTextColor, fontWeight: FontWeight.bold),
    titleLarge: TextStyle(color: darkTextColor, fontWeight: FontWeight.w600),
    bodyLarge: TextStyle(color: darkTextColor),
    bodyMedium: TextStyle(color: darkTextColor.withOpacity(0.8)),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: accentColor,
    foregroundColor: Colors.white,
    elevation: 4,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
  ),
  cardTheme: CardTheme(
    elevation: 3,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    shadowColor: primaryColor.withOpacity(0.3),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: darkCardColor,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade700),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade700),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: primaryColor, width: 2),
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  ),
);

// Default theme set to dark
bool isDarkModeEnabled = true;

// Helper function to get the initial theme
ThemeData getInitialTheme() {
  return isDarkModeEnabled ? appThemeDark : appThemeLight;
}
