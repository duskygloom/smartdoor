import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainTheme {
  static ColorScheme _getColors(Brightness brightness) {
    return ColorScheme.fromSeed(
      seedColor: Colors.purple,
      brightness: brightness,
    );
  }

  static ThemeData _getTheme(ColorScheme colors) {
    final typo = Typography.material2021();
    final TextTheme typoTheme;
    if (colors.brightness == Brightness.dark) {
      typoTheme = typo.white;
    } else {
      typoTheme = typo.black;
    }
    final defaultInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.zero,
      borderSide: BorderSide(color: colors.outline),
    );
    return ThemeData.from(colorScheme: colors, useMaterial3: true)
        .copyWith(textTheme: GoogleFonts.abelTextTheme(typoTheme))
        .copyWith(
          dropdownMenuTheme: DropdownMenuThemeData(
            inputDecorationTheme: InputDecorationTheme(
              border: defaultInputBorder,
            ),
            menuStyle: MenuStyle(
              elevation: WidgetStatePropertyAll(0),
              padding: WidgetStatePropertyAll(EdgeInsets.zero),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              ),
              visualDensity: VisualDensity.standard,
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: defaultInputBorder,
            enabledBorder: defaultInputBorder,
            focusedBorder: defaultInputBorder.copyWith(
              borderSide: BorderSide(color: colors.primary),
            ),
            errorBorder: defaultInputBorder.copyWith(
              borderSide: BorderSide(color: colors.errorContainer),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(colors.primaryContainer),
              foregroundColor: WidgetStatePropertyAll(
                colors.onPrimaryContainer,
              ),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              ),
              fixedSize: WidgetStatePropertyAll(
                Size.fromHeight(kDefaultFontSize * 3),
              ),
            ),
          ),
          cardTheme: CardThemeData(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          ),
        );
  }

  static ThemeData get lightTheme => _getTheme(_getColors(Brightness.light));

  static ThemeData get darkTheme => _getTheme(_getColors(Brightness.dark));

  static Color greenOf(BuildContext context) {
    if (Theme.brightnessOf(context) == Brightness.dark) {
      return Colors.green.shade300;
    } else {
      return Colors.green.shade400;
    }
  }

  static Color redOf(BuildContext context) {
    if (Theme.brightnessOf(context) == Brightness.dark) {
      return Colors.red.shade300;
    } else {
      return Colors.red.shade400;
    }
  }
}
