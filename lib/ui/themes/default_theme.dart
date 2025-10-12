import 'package:flutter/material.dart';
import 'package:xrp_monitor_flutter_admin/ui/layout/common_style.dart';

final ThemeData defaultTheme = ThemeData(
  useMaterial3: true, // ✅ Material 3을 쓰는 경우 명시 추천
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

  // ✅ 색상 체계 정의 (보라색 제거 핵심)
  colorScheme: ColorScheme.fromSeed(
    seedColor: CommonColors.mainBlue,
    primary: CommonColors.mainBlue, // 스위치, 버튼 등 기본 포인트 색
    secondary: CommonColors.subBlue,
    surface: CommonColors.white,
    background: CommonColors.white,
    onPrimary: CommonColors.white,
    onSecondary: CommonColors.mainBlack,
    onSurface: CommonColors.mainBlack,
    onBackground: CommonColors.mainBlack,
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

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: CommonColors.mainBlack, // 다이얼로그/텍스트 버튼 색
      textStyle: const TextStyle(fontWeight: FontWeight.w500),
    ),
  ),

  inputDecorationTheme: const InputDecorationTheme(
    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFD5D5D5), width: 1)),
    border: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFD5D5D5), width: 1)),
    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF00A5DF), width: 1)),
    errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xffF7585F), width: 1)),
  ),

  switchTheme: SwitchThemeData(
    thumbColor: MaterialStateProperty.resolveWith<Color>(
          (states) => states.contains(MaterialState.selected)
          ? CommonColors.mainBlue
          : Colors.grey.shade400,
    ),
    trackColor: MaterialStateProperty.resolveWith<Color>(
          (states) => states.contains(MaterialState.selected)
          ? CommonColors.mainBlue.withOpacity(0.4)
          : Colors.grey.shade300,
    ),
  ),

  dialogTheme: DialogThemeData(
    backgroundColor: CommonColors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  ),

  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: Color(0xFF00A5DF),
  ),
);
