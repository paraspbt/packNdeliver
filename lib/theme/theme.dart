import 'package:flutter/material.dart';
import 'package:pack_n_deliver/theme/app_pallete.dart';

class AppTheme {
  static final appTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppPallete.darkGreen,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: AppPallete.backgroundColor,
    appBarTheme: AppBarTheme(backgroundColor: AppPallete.backgroundColor),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(20),
      filled: true,
      fillColor: AppPallete.onSurfaceColor,
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppPallete.dullGreen, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppPallete.darkGreen, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppPallete.darkGreen, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppPallete.darkGreen, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      hintStyle: const TextStyle(fontSize: 20),
    ),
    // textTheme: const TextTheme(
    //   bodyLarge: TextStyle(overflow: TextOverflow.ellipsis),
    //   bodyMedium: TextStyle(overflow: TextOverflow.ellipsis),
    //   bodySmall: TextStyle(overflow: TextOverflow.ellipsis),
    //   titleLarge: TextStyle(overflow: TextOverflow.ellipsis),
    //   titleMedium: TextStyle(overflow: TextOverflow.ellipsis),
    //   titleSmall: TextStyle(overflow: TextOverflow.ellipsis),
    //   labelLarge: TextStyle(overflow: TextOverflow.ellipsis,),
    //   labelMedium: TextStyle(overflow: TextOverflow.ellipsis),
    //   labelSmall: TextStyle(overflow: TextOverflow.ellipsis),
    // ),
  );
}
