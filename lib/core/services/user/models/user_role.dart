import 'package:json_annotation/json_annotation.dart';

enum UserRole {
  // ignore: constant_identifier_names
  @JsonValue('USER')
  USER,
  // ignore: constant_identifier_names
  @JsonValue('ADMIN')  
  ADMIN;

  String get displayName {
    switch (this) {
      case UserRole.USER:
        return '사용자';
      case UserRole.ADMIN:
        return '관리자';
    }
  }

  String get value => name;
}