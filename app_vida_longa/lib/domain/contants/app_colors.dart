import "package:flutter/material.dart";

class AppColors {
  static const Color blackCard = Color(0xFF161616);
  static const Color backgroundDark = Color(0xFF0E0E0E);
  static const Color lightNightRider = Color(0xFF2E2E2E);
  static const Color dimGray = Color(0xFF666666);
  static const Color borderColor = Color(0xFFC1C1C1);
  static const Color matterhorn = Color(0xFF505050);
  static const Color white = Color(0xFFFEFEFE);
  static const Color veryLightGray = Color(0xFFF7F7F7);
  static const Color lightGray = Color(0xFFF3F6FC);
  static const Color redError = Color(0xFFC80000);
  // static const Color success = Color(0xFF1FB163);
  // static const Color warning = Color(0xF0FF983C);
  // static const Color info = Color(0xFF5B7FDE);
  static const Color hexRed = Color(0xFFF04438);
  static const Color orangeBeermine = Color(0xFFF89A2A);
  static const Color orangeBeermineDark = Color(0xFF945c19);
  static const Color green = Color(0xFF1CC326);

  static const Color primary = Color(0xFF4B39EF);
  static const Color secondary = Color(0xFFEE8B60);
  static const Color tertiary = Color(0xFFFFFFFF);
  static const Color alternate = Color(0xFFE1EDF9);
  static const Color primaryText = Color(0xFFFFFFFF);
  static const Color secondaryText = Color(0xFF95A1AC);
  static const Color primaryBackground = Color(0xFF1E2429);
  static const Color secondaryBackground = Color(0xFF14181B);
  static const Color accent1 = Color(0xFFEEEEEE);
  static const Color accent2 = Color(0xFFE0E0E0);
  static const Color accent3 = Color(0xFF757575);
  static const Color accent4 = Color(0xFF616161);
  static const Color success = Color(0xFF04A24C);
  static const Color warning = Color(0xFFFCDC0C);
  static const Color error = Color(0xFFE21C3D);
  static const Color info = Color(0xFF1C4494);

  static const Color titleColor = Color(0xBB052F72);
  static const Color categoryColor = secondaryText;
  static const Color unselectedTextStyleColor = Color(0xFF3A96D0);
  static const Color selectedTextStyleColor = Color(0xBB115AC6);

  static BoxDecoration backgroundGradient() {
    return const BoxDecoration(
      gradient: RadialGradient(
          colors: [Colors.white, AppColors.info],
          center: Alignment(0, -1.6),
          radius: 1.5),
    );
  }
}
