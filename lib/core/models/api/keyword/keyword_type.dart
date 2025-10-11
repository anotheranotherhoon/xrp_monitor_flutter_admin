import 'package:json_annotation/json_annotation.dart';

enum KeywordType {
  // ignore: constant_identifier_names
  @JsonValue('POSITIVE')
  POSITIVE,
  // ignore: constant_identifier_names
  @JsonValue('NEGATIVE')  
  NEGATIVE,
  // ignore: constant_identifier_names
  @JsonValue('IMPORTANT')
  IMPORTANT;

  String get displayName {
    switch (this) {
      case KeywordType.POSITIVE:
        return '긍정';
      case KeywordType.NEGATIVE:
        return '부정';
      case KeywordType.IMPORTANT:
        return '중요';
    }
  }

  String get value => name;
}