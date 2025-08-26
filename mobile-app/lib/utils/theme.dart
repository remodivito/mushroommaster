import 'package:flutter/material.dart';

/// A theme system for the Mushroom Master app
/// This provides a consistent look and feel across both iOS and Android
class AppTheme {
  // Primary Colors
  static const Color primaryColor = Color(0xFF4CAF50);
  static const Color primaryLightColor = Color(0xFF81C784);
  static const Color primaryDarkColor = Color(0xFF388E3C);
  static const Color secondaryColor = Color(0xFF795548);
  static const Color accentColor = Color(0xFFFFEB3B);

  // Background Colors
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color surfaceColor = Colors.white;
  static const Color scaffoldBackgroundColor = backgroundColor;

  // Text Colors
  static const Color textPrimaryColor = Color(0xFF212121);
  static const Color textSecondaryColor = Color(0xFF757575);
  static const Color textLightColor = Color(0xFFBDBDBD);

  // Semantic Colors
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color warningColor = Color(0xFFF57C00);
  static const Color successColor = Color(0xFF388E3C);
  static const Color infoColor = Color(0xFF1976D2);

  // Edibility Colors
  static const Color edibleColor = Color(0xFF388E3C);
  static const Color inedibleColor = Color(0xFFBDBDBD);
  static const Color poisonousColor = Color(0xFFD32F2F);
  static const Color psychoactiveColor = Color(0xFF9C27B0);
  static const Color medicinalColor = Color(0xFF4CAF50);
  static const Color edibleWithCautionColor = Color(0xFFFF9800);
  static const Color deadlyColour = Color(0xFFB71C1C);
  static const Color choiceColour = Color.fromARGB(255, 66, 245, 173);

  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;

  // Border Radius
  static const double borderRadiusS = 4.0;
  static const double borderRadiusM = 8.0;
  static const double borderRadiusL = 16.0;
  static const double borderRadiusXL = 24.0;

  // Elevation
  static const double elevationS = 1.0;
  static const double elevationM = 2.0;
  static const double elevationL = 4.0;
  static const double elevationXL = 8.0;

  // Icon Sizes
  static const double iconSizeS = 16.0;
  static const double iconSizeM = 24.0;
  static const double iconSizeL = 32.0;
  static const double iconSizeXL = 48.0;

  // Font Sizes
  static const double fontSizeXS = 12.0;
  static const double fontSizeS = 14.0;
  static const double fontSizeM = 16.0;
  static const double fontSizeL = 18.0;
  static const double fontSizeXL = 20.0;
  static const double fontSizeXXL = 24.0;
  static const double fontSizeTitle = 22.0;
  static const double fontSizeHeadline = 28.0;

  // Helper method for confidence color
  static Color getConfidenceColor(double confidence) {
    if (confidence > 0.8) {
      return successColor;
    } else if (confidence > 0.5) {
      return warningColor;
    } else {
      return errorColor;
    }
  }

  // The main theme data
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme(
        primary: primaryColor,
        onPrimary: Colors.white,
        secondary: secondaryColor,
        onSecondary: Colors.white,
        background: backgroundColor,
        onBackground: textPrimaryColor,
        surface: surfaceColor,
        onSurface: textPrimaryColor,
        error: errorColor,
        onError: Colors.white,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      appBarTheme: const AppBarTheme(
        elevation: elevationM,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: fontSizeL,
          fontWeight: FontWeight.w500,
        ),
      ),
      cardTheme: CardTheme(
        elevation: elevationM,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusM),
        ),
        color: surfaceColor,
        clipBehavior: Clip.antiAlias,
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(
          horizontal: spacingM,
          vertical: spacingS,
        ),
        minLeadingWidth: 0,
        minVerticalPadding: spacingS,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: primaryColor,
          elevation: elevationM,
          padding: const EdgeInsets.symmetric(
            horizontal: spacingL,
            vertical: spacingM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusM),
          ),
          textStyle: const TextStyle(
            fontSize: fontSizeM,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor),
          padding: const EdgeInsets.symmetric(
            horizontal: spacingL,
            vertical: spacingM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusM),
          ),
          textStyle: const TextStyle(
            fontSize: fontSizeM,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(
            horizontal: spacingM,
            vertical: spacingS,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadiusM),
          ),
          textStyle: const TextStyle(
            fontSize: fontSizeM,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: elevationM,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surfaceColor,
        indicatorColor: primaryLightColor.withOpacity(0.3),
        labelTextStyle: MaterialStateProperty.all(
          const TextStyle(
            fontSize: fontSizeS,
            fontWeight: FontWeight.w500,
          ),
        ),
        iconTheme: MaterialStateProperty.all(
          const IconThemeData(
            size: iconSizeM,
          ),
        ),
      ),
      iconTheme: const IconThemeData(
        color: primaryColor,
        size: iconSizeM,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: fontSizeHeadline,
          fontWeight: FontWeight.w600,
          color: textPrimaryColor,
        ),
        displayMedium: TextStyle(
          fontSize: fontSizeTitle, 
          fontWeight: FontWeight.w600,
          color: textPrimaryColor,
        ),
        bodyLarge: TextStyle(
          fontSize: fontSizeM,
          color: textPrimaryColor,
        ),
        bodyMedium: TextStyle(
          fontSize: fontSizeS,
          color: textSecondaryColor,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusM),
          borderSide: const BorderSide(color: textLightColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusM),
          borderSide: const BorderSide(color: textLightColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusM),
          borderSide: const BorderSide(color: primaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusM),
          borderSide: const BorderSide(color: errorColor),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacingM,
          vertical: spacingM,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: textLightColor,
        thickness: 1,
        space: spacingM,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primaryColor,
      ),
    );
  }
}