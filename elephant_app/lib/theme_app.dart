import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData themeDataApp = ThemeData(
  primaryColor: const Color.fromRGBO(77, 77, 77, 1),
  colorScheme: ColorScheme.fromSwatch().copyWith(
    secondary: const Color.fromRGBO(135, 206, 250, 1),
    tertiary: Colors.blueGrey,
  ),
  focusColor: const Color.fromRGBO(135, 206, 250, 1),
  textTheme: GoogleFonts.sonoTextTheme(const TextTheme(
    bodyMedium: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.normal,
      color: Color.fromRGBO(77, 77, 77, 1),
    ),
    headlineMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Color.fromRGBO(77, 77, 77, 1),
    ),
  )),
);
