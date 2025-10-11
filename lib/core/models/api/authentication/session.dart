import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:xrp_monitor_flutter_admin/core/models/api/authentication/token.dart';
import 'package:xrp_monitor_flutter_admin/service/authentication/models/auth_model.dart';


part 'session.freezed.dart';

@freezed
abstract class Session with _$Session {
  const factory Session({
    Token? accessToken,
    Token? refreshToken,
    LoginUser? user,
  }) = _Session;

  const Session._();
}
