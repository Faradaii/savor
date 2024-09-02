import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

var textTheme = TextTheme(
  displayLarge: GoogleFonts.gabarito(
      fontSize: 105, fontWeight: FontWeight.w300, letterSpacing: -1.5),
  displayMedium: GoogleFonts.gabarito(
      fontSize: 66, fontWeight: FontWeight.w300, letterSpacing: -0.5),
  displaySmall: GoogleFonts.gabarito(fontSize: 52, fontWeight: FontWeight.w400),
  headlineMedium: GoogleFonts.gabarito(
      fontSize: 37, fontWeight: FontWeight.w400, letterSpacing: 0.25),
  headlineSmall:
      GoogleFonts.gabarito(fontSize: 26, fontWeight: FontWeight.w400),
  titleLarge: GoogleFonts.gabarito(
      fontSize: 22, fontWeight: FontWeight.w500, letterSpacing: 0.15),
  titleMedium: GoogleFonts.gabarito(
      fontSize: 17, fontWeight: FontWeight.w400, letterSpacing: 0.15),
  titleSmall: GoogleFonts.gabarito(
      fontSize: 15, fontWeight: FontWeight.w500, letterSpacing: 0.1),
  bodyLarge: GoogleFonts.montserrat(
      fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
  bodyMedium: GoogleFonts.montserrat(
      fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
  labelLarge: GoogleFonts.montserrat(
      fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.25),
  bodySmall: GoogleFonts.montserrat(
      fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
  labelSmall: GoogleFonts.montserrat(
      fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
);

var lightColorScheme = const ColorScheme(
  primary: Color(0xFFF4CE14),
  onPrimary: Color(0xFF45474B),
  secondary: Color(0xFF495E57),
  onSecondary: Color(0xFFF5F7F8),
  error: Colors.redAccent,
  onError: Color(0xFFF5F7F8),
  surface: Color(0xFFF5F7F8),
  onSurface: Color(0xFF241E30),
  brightness: Brightness.light,
);
