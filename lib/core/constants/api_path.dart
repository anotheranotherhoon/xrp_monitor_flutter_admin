import 'package:flutter/foundation.dart';

enum AppEnvironment { dev, release }

class ApiPath {
  static const AppEnvironment environment =
      kReleaseMode ? AppEnvironment.release : AppEnvironment.dev;
  static const bool isDev = environment == AppEnvironment.dev;

  static const String devDomain = 'http://localhost:3000';
  static const String prodDomain = 'https://xrp-monitor.p-e.kr';

  static String get apiDomain => isDev ? devDomain : prodDomain;

  static String get apiUrl => '$apiDomain/';
}
