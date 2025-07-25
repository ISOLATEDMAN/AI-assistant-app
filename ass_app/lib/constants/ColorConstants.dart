import 'dart:ui';

import 'package:flutter/material.dart';

class AppColors {
  static Color AppMainBgTheme = const Color(0xff72B2FF);
  
  // Text Colors
  static Color primaryTextColor = Colors.white;
  static Color secondaryTextColor = Colors.white.withOpacity(0.8);
  
  // Gradient Colors for Chat Box
  static LinearGradient chatGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF667eea),
      Color(0xFF764ba2),
    ],
  );
  
  // Gradient Colors for Shopping Box
  static LinearGradient shopGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFf093fb),
      Color(0xFFf5576c),
    ],
  );
  
  // Alternative gradient options (you can use these too)
  static LinearGradient chatGradientAlt = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF4facfe),
      Color(0xFF00f2fe),
    ],
  );
  
  static LinearGradient shopGradientAlt = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFa8edea),
      Color(0xFFfed6e3),
    ],
  );
}