import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color primaryColor = Color(0xff005CFF);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  textTheme: textTheme,
  inputDecorationTheme: inputDecorationTheme,
  scaffoldBackgroundColor: const Color(0xff2A2A2E),
);

final TextTheme textTheme = TextTheme(
  headline1: GoogleFonts.epilogue(
      fontSize: 97, fontWeight: FontWeight.w300, letterSpacing: -1.5),
  headline2: GoogleFonts.epilogue(
      fontSize: 61, fontWeight: FontWeight.w300, letterSpacing: -0.5),
  headline3: GoogleFonts.epilogue(fontSize: 48, fontWeight: FontWeight.w400),
  headline4: GoogleFonts.epilogue(
      fontSize: 34, fontWeight: FontWeight.w400, letterSpacing: 0.25),
  headline5: GoogleFonts.epilogue(fontSize: 24, fontWeight: FontWeight.w400),
  headline6: GoogleFonts.epilogue(
      fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 0.15),
  subtitle1: GoogleFonts.epilogue(
      fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15),
  subtitle2: GoogleFonts.epilogue(
      fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
  bodyText1: GoogleFonts.epilogue(
      fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
  bodyText2: GoogleFonts.epilogue(
      fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
  button: GoogleFonts.epilogue(
      fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.25),
  caption: GoogleFonts.epilogue(
      fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
  overline: GoogleFonts.epilogue(
      fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
);

LinearGradient gradient =
    const LinearGradient(colors: [Color(0xff0038F5), Color(0xff9F03FF)]);

InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.0),
    borderSide: const BorderSide(
      width: 0,
      style: BorderStyle.none,
    ),
  ),
  contentPadding: const EdgeInsets.all(25),
  fillColor: const Color(0xff333333),
  filled: true,
  focusColor: primaryColor,
);
