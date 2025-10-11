import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_role.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class User with _$User {
  const factory User({
    required int id,
    required String email,
    required String? nickname,
    required UserRole role,
    required bool isActive,
    @JsonKey(fromJson: _dateTimeFromJson)
    required DateTime createdAt,
    @JsonKey(fromJson: _dateTimeFromJson)
    required DateTime updatedAt,
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

