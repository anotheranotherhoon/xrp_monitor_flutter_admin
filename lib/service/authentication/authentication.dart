import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xrp_monitor_flutter_admin/core/services/base/models/response_model.dart';
import 'package:xrp_monitor_flutter_admin/core/services/session/model/session.dart';
import 'package:xrp_monitor_flutter_admin/core/services/session/model/token.dart';
import 'package:xrp_monitor_flutter_admin/core/services/session/session_service.dart';
import 'package:xrp_monitor_flutter_admin/service/storage/local_storage_service.dart';
import 'models/login_request.dart';
import 'models/auth_model.dart';


part 'authentication.g.dart';

@Riverpod(keepAlive: true)
class Authentication extends _$Authentication {
  static late final Authentication instance;
  late final SessionService _sessionService;
  @override
  Future<Session?> build() async {
    instance = this;
    _sessionService = ref.watch(sessionServiceProvider.notifier);
    final String? accessToken = LocalStorageService.instance.getAccessToken();
    final String? refreshToken = LocalStorageService.instance.getRefreshToken();
    if (accessToken == null) {
      return null;
    }
    final session = Session(
      accessToken: Token(
        token: accessToken,
        expiredAt: DateTime.now().add(const Duration(hours: 3)),
      ),
      refreshToken: refreshToken != null ? Token(
        token: refreshToken,
        expiredAt: DateTime.now().add(const Duration(days: 30)),
      ) : null,
      user: null,
    );
    state = AsyncValue.data(session);
    return session;
  }


  //#region Sign in
  Future<LoginUser?> singInAfter(LoginResult data) async {
    await LocalStorageService.instance.setUserToken(data.accessToken);
    await LocalStorageService.instance.setUserRefreshToken(data.refreshToken);
    late Session session;
    session = Session(
      accessToken: Token(
        token: data.accessToken,
        expiredAt: DateTime.now().add(const Duration(hours: 48)
        ),
      ),
      refreshToken: Token(
        token: data.refreshToken,
        expiredAt: DateTime.now().add(const Duration(days: 30)
        ),
      ),
      user:data.user,
    );
    state = AsyncValue.data(session);
    return data.user;
  }





  void updateToken(String newAccessToken, String newRefreshToken) {
    final Token accessToken = Token(
      token: newAccessToken,
      expiredAt: DateTime.now().add(const Duration(hours: 48)),
    );
    final Token refreshToken = Token(
      token: newRefreshToken,
      expiredAt: DateTime.now().add(const Duration(hours: 48)),
    );
    state = state.whenData(
          (session) => session?.copyWith(
        accessToken: accessToken, refreshToken: refreshToken,),
    );
  }


  void removeSession() {
    LocalStorageService.instance.removeAllToken();
    state = const AsyncValue.data(null);
  }

  void removeAccessSession() {
    LocalStorageService.instance.removeAccessToken();
    state = state.whenData(
          (session) => session?.copyWith(accessToken: null),
    );
  }


  Future<ResponseModel<LoginResult>> login(LoginRequest request) async {
    try {
      final ResponseModel<LoginResult> response = await _sessionService.login(request);
      if (response.success && response.result != null) {
        await singInAfter(response.result!);
      }
      return ResponseModel<LoginResult>(
          success: true,
          result: response.result!,
          type: ResponseType.success
      );
    } catch (e) {
      return ResponseModel<LoginResult>(
        success: false,
        type: ResponseType.alert,
      );
    }
  }

  Future<void> logout() async {
    removeSession();
  }


}