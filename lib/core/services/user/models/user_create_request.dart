import 'package:json_annotation/json_annotation.dart';

part 'user_create_request.g.dart';

@JsonSerializable(includeIfNull: false)
class CreateUserRequest {
  CreateUserRequest({
    required this.meEmail,
    required this.mePassword,
    required this.meNickname,
  });

  final String meEmail;
  final String mePassword;
  final String meNickname;

  factory CreateUserRequest.fromJson(Map<String, dynamic> json) => _$CreateUserRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateUserRequestToJson(this);
}

@JsonSerializable(includeIfNull: false)
class UpdateUserRequest {
  UpdateUserRequest({
    required this.meNickname,
  });

  final String meNickname;

  factory UpdateUserRequest.fromJson(Map<String, dynamic> json) => _$UpdateUserRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateUserRequestToJson(this);
}