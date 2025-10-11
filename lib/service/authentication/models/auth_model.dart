// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_model.g.dart';
part 'auth_model.freezed.dart';



@freezed
abstract class JwtTokenResponse with _$JwtTokenResponse {
  const factory JwtTokenResponse({
    @JsonKey(name: 'tokenType') @Default('') String tokenType,
    @JsonKey(name: 'accessToken') @Default('') String accessToken,
    @JsonKey(name: 'refreshToken') @Default('') String refreshToken,

  }) = _JwtTokenResponse;

  const JwtTokenResponse._();

  factory JwtTokenResponse.fromJson(Map<String, dynamic> json) => _$JwtTokenResponseFromJson(json);
}

@freezed
abstract class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    @JsonKey(name: 'success') @Default(false) bool success,
    @JsonKey(name: 'code') @Default(0) int code,
    @JsonKey(name: 'message') @Default('') String message,
    @JsonKey(name: 'result') LoginResult? result,
  }) = _LoginResponse;

  const LoginResponse._();

  factory LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);
}

@freezed
abstract class LoginResult with _$LoginResult {
  const factory LoginResult({
    @JsonKey(name: 'accessToken') @Default('') String accessToken,
    @JsonKey(name: 'refreshToken') @Default('') String refreshToken,
    @JsonKey(name: 'user') LoginUser? user,
  }) = _LoginResult;

  const LoginResult._();

  factory LoginResult.fromJson(Map<String, dynamic> json) => _$LoginResultFromJson(json);
}

@freezed
abstract class LoginUser with _$LoginUser {
  const factory LoginUser({
    @JsonKey(name: 'id') @Default(0) int id,
    @JsonKey(name: 'email') @Default('') String email,
    @JsonKey(name: 'nickname') @Default('') String nickname,
    @JsonKey(name: 'createdAt') @Default('') String createdAt,
  }) = _LoginUser;

  const LoginUser._();

  factory LoginUser.fromJson(Map<String, dynamic> json) => _$LoginUserFromJson(json);
}


