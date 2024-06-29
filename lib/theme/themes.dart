import 'package:flutter/material.dart';

class CustomThemes {
  final ThemeData lightMode = ThemeData(
    useMaterial3: true,
    colorScheme: flexSchemeLight,
  );
  final ThemeData darkMode = ThemeData(
    useMaterial3: true,
    colorScheme: flexSchemeDark,
  );

  // Light and dark ColorSchemes made by FlexColorScheme v7.3.1.
// These ColorScheme objects require Flutter 3.7 or later.
  static const ColorScheme flexSchemeLight = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xff1d2228),
    onPrimary: Color(0xffffffff),
    primaryContainer: Color(0xffb0b2c0),
    onPrimaryContainer: Color(0xff0f0f10),
    secondary: Color(0xffea9654),
    onSecondary: Color(0xff000000),
    secondaryContainer: Color(0xffe9cbab),
    onSecondaryContainer: Color(0xff13110e),
    tertiary: Color(0xfffb8122),
    onTertiary: Color(0xff000000),
    tertiaryContainer: Color(0xffffb680),
    onTertiaryContainer: Color(0xff140f0b),
    error: Color(0xffba1a1a),
    onError: Color(0xffffffff),
    errorContainer: Color(0xffffdad6),
    onErrorContainer: Color(0xff410002),
    surface: Color(0xfff8f8f9),
    onSurface: Color(0xff090909),
    surfaceContainerHighest: Color(0xffe2e2e3),
    onSurfaceVariant: Color(0xff111111),
    outline: Color(0xff7c7c7c),
    outlineVariant: Color(0xffc8c8c8),
    shadow: Color(0xff000000),
    scrim: Color(0xff000000),
    inverseSurface: Color(0xff111111),
    onInverseSurface: Color(0xfff5f5f5),
    inversePrimary: Color(0xff9ea2a6),
    surfaceTint: Color(0xff1d2228),
  );

  static const ColorScheme flexSchemeDark = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xff777a7e),
    onPrimary: Color(0xfff8f8f8),
    primaryContainer: Color(0xff313c42),
    onPrimaryContainer: Color(0xffe7e9ea),
    secondary: Color(0xffefb383),
    onSecondary: Color(0xff14120e),
    secondaryContainer: Color(0xffa75f27),
    onSecondaryContainer: Color(0xfff9eee5),
    tertiary: Color(0xfffcb075),
    onTertiary: Color(0xff14110d),
    tertiaryContainer: Color(0xffd97b18),
    onTertiaryContainer: Color(0xfffff3e3),
    error: Color(0xffffb4ab),
    onError: Color(0xff690005),
    errorContainer: Color(0xff93000a),
    onErrorContainer: Color(0xffffb4ab),
    surface: Color(0xff161616),
    onSurface: Color(0xffececec),
    surfaceContainerHighest: Color(0xff393939),
    onSurfaceVariant: Color(0xffdfdfdf),
    outline: Color(0xff797979),
    outlineVariant: Color(0xff2d2d2d),
    shadow: Color(0xff000000),
    scrim: Color(0xff000000),
    inverseSurface: Color(0xfff8f8f8),
    onInverseSurface: Color(0xff131313),
    inversePrimary: Color(0xff424344),
    surfaceTint: Color(0xff777a7e),
  );

}
