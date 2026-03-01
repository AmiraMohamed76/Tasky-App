import 'package:flutter/material.dart';

import '../constants/app_sizes.dart';

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primaryContainer: Color(0xFF282828),
    primary: Colors.transparent,
    onPrimary: Color(0xFF6E6E6E),
    secondary: Color(0xFFC6C6C6),
    surface: Color(0xFFC6C6C6),
    onSecondary: Color(0xFF15B86C),
    onSurface: Color(0xFF6D6D6D),
  ),
  scaffoldBackgroundColor: Color(0xFF181818),
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF181818),
    titleTextStyle: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: AppSizes.sp20,
      color: Color(0xFFFFFCFC),
    ),
    iconTheme: IconThemeData(color: Color(0xFFFFFCFC)),
    centerTitle: true,
  ),
  switchTheme: SwitchThemeData(
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return Color(0xFF15B86C);
      }
      return Colors.white;
    }),
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.white;
      }
      return Color(0xFF9E9E9E);
    }),
    trackOutlineColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return null;
      }
      return Color(0xFF9E9E9E);
    }),
    trackOutlineWidth: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return 0;
      }
      return 2;
    }),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Color(0xFFFFFCFC),
      backgroundColor: Color(0xFF15B86C),
      minimumSize:  Size.fromHeight(AppSizes.h40),
      textStyle: TextStyle(
        fontSize: AppSizes.sp14,
        fontWeight: FontWeight.w500,
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: Colors.white),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF15B86C),
    foregroundColor: Color(0xFFFFFCFC),
    extendedTextStyle: TextStyle(
      fontSize: AppSizes.sp14,
      fontWeight: FontWeight.w500,
    ),
  ),
  textTheme: TextTheme(
    displaySmall: TextStyle(
      fontSize: AppSizes.sp24,
      fontWeight: FontWeight.w400,
      color: Color(0xFFFFFCFC),
    ),
    displayMedium: TextStyle(
      color: Color(0xFFFFFFFF),
      fontSize: AppSizes.sp28,
      fontWeight: FontWeight.w400,
    ),
    displayLarge: TextStyle(
      fontSize: AppSizes.sp32,
      fontWeight: FontWeight.w400,
      color: Color(0xFFFFFCFC),
    ),
    labelSmall: TextStyle(
      color: Color(0xFFC6C6C6),
      fontSize: AppSizes.sp20,
      fontWeight: FontWeight.w400,
    ),
    labelLarge: TextStyle(color: Colors.white, fontSize: AppSizes.sp24),
    labelMedium: TextStyle(color: Colors.white),
    titleSmall: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: AppSizes.sp14,
      color: Color(0xFFC6C6C6),
    ),
    titleMedium: TextStyle(
      fontSize: AppSizes.sp16,
      fontWeight: FontWeight.w400,
      color: Color(0xFFFFFCFC),
      overflow: TextOverflow.ellipsis,
    ),
    titleLarge: TextStyle(
      fontSize: AppSizes.sp16,
      fontWeight: FontWeight.w400,
      color: Color(0xFFA0A0A0),
      decoration: TextDecoration.lineThrough,
      decorationColor: Color(0xFFA0A0A0),
      overflow: TextOverflow.ellipsis,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    hintStyle: TextStyle(color: Color(0xFF6D6D6D)),
    filled: true,
    fillColor: Color(0xFF282828),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: Colors.red, width: 0.7),
    ),
  ),
  checkboxTheme: CheckboxThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    side: BorderSide(color: Color(0xFF6E6E6E), width: 2),
  ),
  iconTheme: IconThemeData(color: Color(0xFFFFFCFC)),
  dividerTheme: DividerThemeData(color: Color(0xFF6E6E6E), thickness: 1),
  listTileTheme: ListTileThemeData(
    titleTextStyle: TextStyle(
      color: Color(0xFFC6C6C6),
      fontSize: AppSizes.sp16,
      fontWeight: FontWeight.w400,
    ),
  ),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: Colors.white,
    selectionHandleColor: Colors.white,
    selectionColor: Colors.white,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF181818),
    type: BottomNavigationBarType.fixed,
    unselectedItemColor: Color(0xFFC6C6C6),
    selectedItemColor: Color(0xFF15B86C),
  ),
  splashFactory: NoSplash.splashFactory,
  popupMenuTheme: PopupMenuThemeData(
    color: Color(0xFF181818),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    elevation: 2,
    shadowColor: Colors.grey,
    menuPadding: EdgeInsets.only(bottom: 0),
    labelTextStyle: WidgetStateProperty.all(
      TextStyle(fontSize: AppSizes.sp16, fontWeight: FontWeight.w400),
    ),
  ),
);
