import 'package:flutter/material.dart';
import 'package:xrp_monitor_flutter_admin/ui/layout/common_style.dart';

final ThemeData defaultTheme = ThemeData(
  primaryColor: CommonColors.mainBlue,
  secondaryHeaderColor: CommonColors.subBlue,
  scaffoldBackgroundColor: CommonColors.white,
  fontFamily: 'PretendardJP',
  splashColor: const Color(0xFF00A5DF).withOpacity(0.2),
  highlightColor: const Color(0xFF00A5DF).withOpacity(0.1),
  appBarTheme: const AppBarTheme(
    toolbarHeight: 44,
    elevation: 0,
    backgroundColor: Colors.white,
  ),

  textTheme: TextTheme(
    bodyLarge: TextStyle(fontSize: 16, color: CommonColors.mainBlack),
    bodyMedium: TextStyle(fontSize: 14, color: CommonColors.mainBlack),
    labelSmall: TextStyle(fontSize: 12, color: CommonColors.mainBlack),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF00A5DF),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      textStyle: TextStyle(color: CommonColors.white, fontWeight: FontWeight.w400),
      foregroundColor: CommonColors.white,
      disabledForegroundColor: CommonColors.white,
      disabledBackgroundColor: const Color(0xff959595),
      padding: const EdgeInsets.symmetric(vertical: 12),
    ),
  ),

  inputDecorationTheme: const InputDecorationTheme(
    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFD5D5D5), width: 1)),
    border: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFD5D5D5), width: 1)),
    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF00A5DF), width: 1)),
    errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xffF7585F), width: 1)),
  ),

  textSelectionTheme: const TextSelectionThemeData(cursorColor: Color(0xFF00A5DF)),
);
