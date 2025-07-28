import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // WhatsApp Web Color Scheme
  static const Color primaryColor = Color(0xFF00A884);
  static const Color primaryColorDark = Color(0xFF008069);
  static const Color accentColor = Color(0xFF25D366);
  
  // Light Theme Colors (WhatsApp Web)
  static const Color backgroundColor = Color(0xFFF0F2F5);
  static const Color backgroundColorDark = Color(0xFF111B21);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color surfaceColorDark = Color(0xFF202C33);
  static const Color cardColor = Color(0xFFFFFFFF);
  static const Color cardColorDark = Color(0xFF2A3942);
  
  // WhatsApp Text Colors
  static const Color textPrimary = Color(0xFF111B21);
  static const Color textPrimaryDark = Color(0xFFE9EDEF);
  static const Color textSecondary = Color(0xFF667781);
  static const Color textSecondaryDark = Color(0xFF8696A0);
  
  // WhatsApp UI Colors
  static const Color dividerColor = Color(0xFFD1D7DB);
  static const Color dividerColorDark = Color(0xFF3B4A54);
  static const Color headerColor = Color(0xFFEDEDED);
  static const Color headerColorDark = Color(0xFF2A3942);
  
  // WhatsApp Message Colors
  static const Color sentMessageColor = Color(0xFFD9FDD3);
  static const Color sentMessageColorDark = Color(0xFF005C4B);
  static const Color receivedMessageColor = Color(0xFFFFFFFF);
  static const Color receivedMessageColorDark = Color(0xFF202C33);
  
  // WhatsApp Chat Background
  static const Color chatBackgroundColor = Color(0xFFE5DDD5);
  static const Color chatBackgroundColorDark = Color(0xFF0B141A);

  // Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: accentColor,
      surface: surfaceColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: textPrimary,
    ),
    
    // Text Theme with WhatsApp-like typography
    textTheme: GoogleFonts.robotoTextTheme().copyWith(
      displayLarge: GoogleFonts.roboto(
        fontSize: 32,
        fontWeight: FontWeight.w300,
        color: textPrimary,
      ),
      displayMedium: GoogleFonts.roboto(
        fontSize: 28,
        fontWeight: FontWeight.w300,
        color: textPrimary,
      ),
      displaySmall: GoogleFonts.roboto(
        fontSize: 24,
        fontWeight: FontWeight.w400,
        color: textPrimary,
      ),
      headlineLarge: GoogleFonts.roboto(
        fontSize: 22,
        fontWeight: FontWeight.w400,
        color: textPrimary,
      ),
      headlineMedium: GoogleFonts.roboto(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        color: textPrimary,
      ),
      headlineSmall: GoogleFonts.roboto(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: textPrimary,
      ),
      titleLarge: GoogleFonts.roboto(
        fontSize: 17,
        fontWeight: FontWeight.w400,
        color: textPrimary,
      ),
      titleMedium: GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textPrimary,
      ),
      titleSmall: GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textSecondary,
      ),
      bodyLarge: GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textPrimary,
      ),
      bodyMedium: GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textPrimary,
      ),
      bodySmall: GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textSecondary,
      ),
      labelLarge: GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textPrimary,
      ),
      labelMedium: GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textSecondary,
      ),
      labelSmall: GoogleFonts.roboto(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: textSecondary,
      ),
    ),

    // Card Theme
    cardTheme: CardTheme(
      color: cardColor,
      elevation: 1,
      shadowColor: Colors.black.withOpacity(0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),

    // App Bar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: headerColor,
      foregroundColor: textPrimary,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textPrimary,
      ),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: dividerColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: dividerColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.red),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      hintStyle: GoogleFonts.roboto(
        color: textSecondary,
        fontSize: 14,
      ),
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: GoogleFonts.roboto(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),

    // Icon Theme
    iconTheme: IconThemeData(
      color: Color(0xFF54656F),
      size: 24,
    ),

    // Divider Theme
    dividerTheme: DividerThemeData(
      color: dividerColor,
      thickness: 1,
      space: 1,
    ),
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColorDark,
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: accentColor,
      surface: surfaceColorDark,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: textPrimaryDark,
    ),
    
    // Text Theme for dark mode
    textTheme: GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme).copyWith(
      displayLarge: GoogleFonts.roboto(
        fontSize: 32,
        fontWeight: FontWeight.w300,
        color: textPrimaryDark,
      ),
      displayMedium: GoogleFonts.roboto(
        fontSize: 28,
        fontWeight: FontWeight.w300,
        color: textPrimaryDark,
      ),
      displaySmall: GoogleFonts.roboto(
        fontSize: 24,
        fontWeight: FontWeight.w400,
        color: textPrimaryDark,
      ),
      headlineLarge: GoogleFonts.roboto(
        fontSize: 22,
        fontWeight: FontWeight.w400,
        color: textPrimaryDark,
      ),
      headlineMedium: GoogleFonts.roboto(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        color: textPrimaryDark,
      ),
      headlineSmall: GoogleFonts.roboto(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: textPrimaryDark,
      ),
      titleLarge: GoogleFonts.roboto(
        fontSize: 17,
        fontWeight: FontWeight.w400,
        color: textPrimaryDark,
      ),
      titleMedium: GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textPrimaryDark,
      ),
      titleSmall: GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textSecondaryDark,
      ),
      bodyLarge: GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textPrimaryDark,
      ),
      bodyMedium: GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textPrimaryDark,
      ),
      bodySmall: GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textSecondaryDark,
      ),
      labelLarge: GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textPrimaryDark,
      ),
      labelMedium: GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textSecondaryDark,
      ),
      labelSmall: GoogleFonts.roboto(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: textSecondaryDark,
      ),
    ),

    // Card Theme for dark mode
    cardTheme: CardTheme(
      color: cardColorDark,
      elevation: 1,
      shadowColor: Colors.black.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),

    // App Bar Theme for dark mode
    appBarTheme: AppBarTheme(
      backgroundColor: headerColorDark,
      foregroundColor: textPrimaryDark,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textPrimaryDark,
      ),
    ),

    // Input Decoration Theme for dark mode
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceColorDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: dividerColorDark),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: dividerColorDark),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.red),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      hintStyle: GoogleFonts.roboto(
        color: textSecondaryDark,
        fontSize: 14,
      ),
    ),

    // Elevated Button Theme for dark mode
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: GoogleFonts.roboto(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),

    // Icon Theme for dark mode
    iconTheme: IconThemeData(
      color: textSecondaryDark,
      size: 24,
    ),

    // Divider Theme for dark mode
    dividerTheme: DividerThemeData(
      color: dividerColorDark,
      thickness: 1,
      space: 1,
    ),
  );
}