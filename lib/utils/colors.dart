import 'package:flutter/material.dart';

// Brand Logo Colors
const brandColorPrimary = Color(0xFF4DC5C9);  // Blue from logo
const brandColorSecondary = Color(0xFF3B2D7F); // Dark blue/purple from logo
const brandColorSecondaryLight = Color(0xFF5A4C9F); // Lighter variant of secondary
const brandColorAccent = Color(0xFFF67E7D);  // Optional accent (e.g. coral) if used in brand

// App Theme Colors - Use these in your UI
const appColorPrimary = brandColorPrimary;
const appColorSecondary = brandColorSecondary;

// Primary Color Variants
const lightPrimaryColor = Color(0xFFE1F4F7);       // Light tint of primary
const extraLightPrimaryColor = Color(0xFFF5F6FA);  // Very light tint of primary
const darkPrimaryColor = Color(0xFF4AB5C6);        // Darker shade of primary

// Secondary Color Variants
const lightSecondaryColor = Color(0xFFEBEAF2);     // Light tint of secondary
const darkSecondaryColor = Color(0xFF262057);      // Darker shade of secondary

// Background Colors
const appScreenBackground = Color(0xFFF5F6FA);     // Main screen background
const appScreenBackgroundDark = Color(0xFF121212); // Dark mode background - improved
const appLayoutBackground = Color(0xFFFAF8FF);     // Layout background
const appSectionBackground = Color(0xFFFFFFFF);    // Section background
const appScreenGreyBackground = Color(0xFFF7F7F7); // Grey background variant

// Semantic Colors
const successColor = Color(0xFF2CB562);            // Success/completed status
const warningColor = Color(0xFFFFCE70);            // Warning/upcoming status
const errorColor = Color(0xFFF04336);              // Error/cancelled status
const infoColor = appColorPrimary;                 // Info/confirmed status
const pendingColor = Color(0xFFFD866E);            // Pending status
const inProgressColor = Color(0xFFE56F0F);         // In progress status

// Canvas/Container Colors
const canvasColor = Color(0xFF1E1E24);
const canvasColorDark = Color(0xFF1E1E24);         // Improved dark mode canvas
const fullDarkCanvasColor = Color(0xFF272B35);
const fullDarkCanvasColorDark = Color(0xFF1A1A1A); // Improved dark mode full dark canvas
const lightCanvasColor = Color(0xFF384052);
const mediumCanvasColor = Color(0XFF303030);

// Text Colors
const primaryTextColor = Color(0xFF11104A);        // Main text color - use for headings
const secondaryTextColor = Color(0xFF7C7E93);      // Secondary text - use for subtitles
const whiteTextColor = Color(0xFFFFFFFF);
const blackTextColor = Color(0xFF000000);
const darkGrayTextColor = Color(0xFF3F414D);
const darkGrayGeneral = Color(0xFF6C757D);

// Border & Divider Colors
const borderColor = Color(0xFFD8D9D9);
const borderColorDark = Color(0xFF2A2A2A);         // Improved dark mode border
const dividerColor = Color(0xFF828A90);
const whiteBorderColor = Color(0xFFF3F3FF);
const appBodyColor = Color(0xFF828A90);

// Status Colors (using semantic colors for consistency)
const pendingStatusColor = pendingColor;
const upcomingStatusColor = warningColor;
const confirmedStatusColor = infoColor;
const completedStatusColor = successColor;
const cancelStatusColor = errorColor;
const defaultStatusColor = primaryTextColor;
const inprogressStatusColor = inProgressColor;

// Utility Colors
const appTransparentColor = Colors.transparent;
const bodyWhite = Color(0xFFA6A6A6);
const bodyWhiteType = Color(0xFFFAFAFA);
const appColorlightGray = Color(0xFFF5F5F5);
const resetTextColor = Color(0xFF48D0B8);
const deleteTextColor = Color(0xFFD76161);
const redTextColor = Color(0xFFFF3E3E);
const lightGreenColor = Color(0xFFEFF8F3);

// Switch Colors
const switchActiveTrackColor = appColorPrimary;
const switchActiveColor = Colors.white;
const switchColor = Color(0xFF808080);
const iconColor = Color(0xFF6E8192);

// Dark Theme Colors - Improved for better contrast and readability
const appBackgroundColorDark = Color(0xFF121212);      // Darker background
const appBackgroundSecondaryColorDark = Color(0xFF1E1E1E); // Slightly lighter dark background
const colorPrimaryBlack = Color(0xFF121212);
const darkHeadingColor = Color(0xFFE0E0E0);           // Lighter text for dark mode headings
const appDarkBodyColor = Color(0xFFB0B0B0);           // Lighter text for dark mode body
const iconColorPrimaryDark = Color(0xFFB0B0B0);       // Lighter icons for dark mode
const appShadowColorDark = Color(0xFF000000);         // Pure black shadow for dark mode
const cardBackgroundBlackDark = Color(0xFF1E1E1E);    // Card background for dark mode

// Schedule-specific colors - Professional color palette
const scheduleLeavesColor = Color(0xFF4A90E2);        // Professional blue for leaves
const scheduleHolidaysColor = Color(0xFF50C878);      // Professional green for holidays
const scheduleShiftsColor = Color(0xFFF5A623);        // Professional orange for shifts
const scheduleOvertimeColor = Color(0xFF9B6EF3);      // Professional purple for overtime

// Dark mode schedule colors - Adjusted for better visibility
const scheduleLeavesColorDark = Color(0xFF5A9EE2);    // Brighter blue for dark mode
const scheduleHolidaysColorDark = Color(0xFF60D888);  // Brighter green for dark mode
const scheduleShiftsColorDark = Color(0xFFFFB643);    // Brighter orange for dark mode
const scheduleOvertimeColorDark = Color(0xFFAB86F3);  // Brighter purple for dark mode
