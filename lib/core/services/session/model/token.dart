import 'package:freezed_annotation/freezed_annotation.dart';

part 'token.freezed.dart';

@freezed
abstract class Token with _$Token {
  const factory Token({
    required String token,
    required DateTime expiredAt,
  }) = _Token;

  const Token._();

  bool get expired => DateTime.now().compareTo(expiredAt) >= 0;
}
