import 'package:flutter/material.dart';

class ResponsiveSizes {
  final double titleFontSize;
  final double descriptionFontSize;
  final double welcomeFontSize;
  final double subtitleFontSize;
  final double buttonHeight;
  final double inputHeight;

  ResponsiveSizes({
    required this.titleFontSize,
    required this.descriptionFontSize,
    required this.welcomeFontSize,
    required this.subtitleFontSize,
    required this.buttonHeight,
    required this.inputHeight,
  });

  factory ResponsiveSizes.fromContext(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
    final isMediumScreen = screenSize.width < 600;

    return ResponsiveSizes(
      titleFontSize: isSmallScreen ? 28.0 : isMediumScreen ? 32.0 : 34.0,
      descriptionFontSize: isSmallScreen ? 14.0 : isMediumScreen ? 15.0 : 16.0,
      welcomeFontSize: isSmallScreen ? 20.0 : 22.0,
      subtitleFontSize: isSmallScreen ? 13.0 : 14.0,
      buttonHeight: isSmallScreen ? 50.0 : 56.0,
      inputHeight: isSmallScreen ? 50.0 : 56.0,
    );
  }
}