// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_role.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class User with _$User {
  const factory User({
    @JsonKey(name: 'meIdx') @Default(0) int key,
    @JsonKey(name: 'meEmail') @Default("") String email,
    @JsonKey(name: 'meNickname') @Default("") String nickname,
    @JsonKey(name: 'meRole') @Default(UserRole.USER) UserRole role,
    @JsonKey(name: 'meIsActive	') @Default(false) bool isActive,
    @JsonKey(name: 'createdAt') @Default("") String createdAt,
    @JsonKey(name: 'updatedAt') @Default("") String updatedAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

DateTime _dateTimeFromJson(dynamic value) {
  if (value is String) {
    return DateTime.parse(value);
  }
  if (value is DateTime) {
    return value;
  }
  throw ArgumentError('Cannot parse DateTime from $value');
}

