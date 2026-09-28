import 'package:flutter/material.dart';

extension ResponsiveExtension on BuildContext {
  // Screen Dimensions
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;

  // Dynamic Height & Width (%)
  double h(double percentage) => screenHeight * (percentage / 100);
  double w(double percentage) => screenWidth * (percentage / 100);

  // Device Type Checkers
  bool get isMobile => screenWidth < 600;
  bool get isTablet => screenWidth >= 600;
}