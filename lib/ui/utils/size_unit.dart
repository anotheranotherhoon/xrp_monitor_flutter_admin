import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonSize {
  static double vh = 0;
  static double vw = 0;
  static double safePaddingTop = 0;
  static double safePaddingBottom = 0;
  static double safeTopVh = 0;
  static double safeLeft = 0;
  static double safeRight = 0;
  static double safeBottomVh = 0;
  static double safeVh = 0;
  static double safeAppbarVh = 0;
  static double commonBottom = 0;
  static double footerBottom = 0;
  static double keyboardHeight = 0;
  static double pixelRatio = 0;

  static double designWidth = 360;

  static setSizes(context) {
    vh = MediaQuery.of(context).size.height;
    vw = MediaQuery.of(context).size.width;
    safePaddingTop = MediaQuery.of(context).padding.top;
    safeLeft = MediaQuery.of(context).padding.left;
    safeRight = MediaQuery.of(context).padding.right;
    safePaddingBottom = MediaQuery.of(context).padding.bottom;
    safeTopVh = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    safeBottomVh = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.bottom;
    safeVh =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.bottom - MediaQuery.of(context).padding.top;
    safeAppbarVh =
        MediaQuery.of(context).size.height -
            MediaQuery.of(context).padding.bottom -
            MediaQuery.of(context).padding.top -
            48.w;
    commonBottom = MediaQuery.of(context).padding.bottom + 30.w;
    keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    footerBottom = 30.w;

    pixelRatio = MediaQuery.of(context).devicePixelRatio;
  }

  static setDesignWidth(double width) {
    designWidth = width;
  }

  static double keyboardBottom(context) {
    return MediaQuery.of(context).padding.bottom;
  }

  static double keyboardMediaHeight(context) {
    return MediaQuery.of(context).viewInsets.bottom;
  }

  static double commonBoard(context) {
    return MediaQuery.of(context).padding.bottom + 30.w;
  }

  static ValueNotifier<double> designWidthNotifier = ValueNotifier(designWidth);
}
