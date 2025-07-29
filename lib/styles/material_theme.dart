import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class AppMaterialTheme {
  const AppMaterialTheme._();

  // static final lightTheme = _buildTheme(lightColorScheme);
  // static final darkTheme = _buildTheme(darkColorScheme);

  static ThemeData _buildTheme(ColorScheme scheme) => ThemeData(
        fontFamily: 'Quicksand',
        textTheme: GoogleFonts.quicksandTextTheme(),
        useMaterial3: true,
        colorScheme: scheme,
        appBarTheme: const AppBarTheme(
          scrolledUnderElevation: 0.0,
        ),
        cardTheme: CardThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: const BorderSide(),
          ),
        ),
        brightness: scheme.brightness,
      );
}
