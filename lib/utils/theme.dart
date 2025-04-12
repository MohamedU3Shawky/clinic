import 'package:flutter/material.dart';
import '../constants/colors.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: AppColors.primary,
  scaffoldBackgroundColor: AppColors.background,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  cardTheme: CardTheme(
    color: AppColors.surface,
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      color: AppColors.textPrimary,
      fontSize: 32,
      fontWeight: FontWeight.bold,
    ),
    displayMedium: TextStyle(
      color: AppColors.textPrimary,
      fontSize: 28,
      fontWeight: FontWeight.bold,
    ),
    displaySmall: TextStyle(
      color: AppColors.textPrimary,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    bodyLarge: TextStyle(
      color: AppColors.textPrimary,
      fontSize: 16,
    ),
    bodyMedium: TextStyle(
      color: AppColors.textSecondary,
      fontSize: 14,
    ),
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: AppColors.primaryDark,
  scaffoldBackgroundColor: AppColors.backgroundDark,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.primaryDark,
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  cardTheme: CardTheme(
    color: AppColors.surfaceDark,
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      color: AppColors.textPrimaryDark,
      fontSize: 32,
      fontWeight: FontWeight.bold,
    ),
    displayMedium: TextStyle(
      color: AppColors.textPrimaryDark,
      fontSize: 28,
      fontWeight: FontWeight.bold,
    ),
    displaySmall: TextStyle(
      color: AppColors.textPrimaryDark,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    bodyLarge: TextStyle(
      color: AppColors.textPrimaryDark,
      fontSize: 16,
    ),
    bodyMedium: TextStyle(
      color: AppColors.textSecondaryDark,
      fontSize: 14,
    ),
  ),
);
