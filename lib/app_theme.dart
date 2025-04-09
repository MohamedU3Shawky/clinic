import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart' hide errorColor;

import 'utils/colors.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: appScreenBackground,
    primaryColor: appColorPrimary,
    primaryColorDark: darkPrimaryColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: appColorPrimary,
      primary: appColorPrimary,
      secondary: appColorSecondary,
      brightness: Brightness.light,
      tertiary: brandColorAccent,
      surface: appSectionBackground,
      background: appScreenBackground,
      error: errorColor,
    ),
    useMaterial3: true,
    hoverColor: Colors.white54,
    dividerColor: dividerColor,
    fontFamily: GoogleFonts.interTight().fontFamily,
    drawerTheme: const DrawerThemeData(backgroundColor: appScreenBackground),
    appBarTheme: AppBarTheme(
      surfaceTintColor: appLayoutBackground,
      color: appLayoutBackground,
      iconTheme: const IconThemeData(color: primaryTextColor),
      titleTextStyle: TextStyle(
        color: canvasColor,
        fontFamily: GoogleFonts.interTight().fontFamily,
      ),
      systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.dark),
    ),
    tabBarTheme: const TabBarTheme(
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: appColorPrimary, width: 3)
      )
    ),
    textSelectionTheme: const TextSelectionThemeData(cursorColor: appColorPrimary),
    cardTheme: const CardTheme(color: appSectionBackground),
    cardColor: appSectionBackground,
    iconTheme: const IconThemeData(color: primaryTextColor),
    bottomSheetTheme: const BottomSheetThemeData(backgroundColor: whiteTextColor),
    textTheme: GoogleFonts.interTightTextTheme().apply(
      bodyColor: primaryTextColor,
      displayColor: primaryTextColor,
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.all(appColorPrimary),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.all(appColorPrimary),
      checkColor: WidgetStateProperty.all(whiteTextColor),
    ),
    buttonTheme: const ButtonThemeData(buttonColor: appColorPrimary),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: appColorPrimary,
        foregroundColor: whiteTextColor,
      ),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.linux: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.macOS: OpenUpwardsPageTransitionsBuilder(),
      },
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: appScreenBackgroundDark,
    primaryColor: appColorPrimary,
    primaryColorDark: darkPrimaryColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: appColorPrimary,
      primary: appColorPrimary,
      secondary: appColorSecondary,
      brightness: Brightness.dark,
      tertiary: brandColorAccent,
      surface: fullDarkCanvasColor,
      background: appScreenBackgroundDark,
      error: errorColor,
    ),
    useMaterial3: true,
    hoverColor: Colors.black12,
    dividerColor: canvasColor,
    fontFamily: GoogleFonts.interTight().fontFamily,
    drawerTheme: const DrawerThemeData(backgroundColor: fullDarkCanvasColorDark),
    appBarTheme: AppBarTheme(
      surfaceTintColor: appScreenBackgroundDark,
      color: appScreenBackgroundDark,
      iconTheme: const IconThemeData(color: whiteTextColor),
      titleTextStyle: TextStyle(
        color: whiteTextColor,
        fontFamily: GoogleFonts.interTight().fontFamily,
      ),
      systemOverlayStyle: const SystemUiOverlayStyle(statusBarBrightness: Brightness.light, statusBarIconBrightness: Brightness.light),
    ),
    tabBarTheme: const TabBarTheme(
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: appColorPrimary, width: 3)
      )
    ),
    textSelectionTheme: const TextSelectionThemeData(cursorColor: appColorPrimary),
    cardTheme: const CardTheme(color: fullDarkCanvasColor),
    cardColor: fullDarkCanvasColor,
    iconTheme: const IconThemeData(color: whiteTextColor),
    bottomSheetTheme: const BottomSheetThemeData(backgroundColor: appBackgroundColorDark),
    textTheme: GoogleFonts.interTightTextTheme().apply(
      bodyColor: whiteTextColor,
      displayColor: whiteTextColor,
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.all(appColorPrimary),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.all(appColorPrimary),
      checkColor: WidgetStateProperty.all(whiteTextColor),
    ),
    buttonTheme: const ButtonThemeData(buttonColor: appColorPrimary),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: appColorPrimary,
        foregroundColor: whiteTextColor,
      ),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.linux: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.macOS: OpenUpwardsPageTransitionsBuilder(),
      },
    ),
  );
}
