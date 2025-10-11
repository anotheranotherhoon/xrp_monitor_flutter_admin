import 'dart:developer';

import 'package:xrp_monitor_flutter_admin/core/constants/api_path.dart';
import 'package:xrp_monitor_flutter_admin/core/services/base/models/api_response.dart';
import 'package:xrp_monitor_flutter_admin/core/services/base/api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xrp_monitor_flutter_admin/core/services/base/models/response_model.dart';
import 'package:xrp_monitor_flutter_admin/service/authentication/models/auth_model.dart';
import 'package:xrp_monitor_flutter_admin/service/authentication/models/login_request.dart';

part 'session_service.g.dart';

@riverpod
class SessionService extends _$SessionService {
  late final ApiService _apiService;

  @override
  void build() {
    _apiService = ref.read(apiServiceProvider.notifier);
  }


  Future<ResponseModel<LoginResult>> login(LoginRequest request) async {
    try {
      final response = await _apiService.post(
        url: '${ApiPath.apiUrl}auth/login',
        params: request.toJson(),
      );
      if (response.statusCode == 200) {
        final ApiResponse apiResponse = ApiResponse.fromJson(response.data!);
        final LoginResult loginUser = LoginResult.fromJson(apiResponse.result?.data);
        return ResponseModel(
          success: true,
          type: ResponseType.success,
          result: loginUser,
        );
      } else {
        return ResponseModel(
          success: false,
          type: ResponseType.alert,
          title: "로그인 실패",
          content: "이메일 또는 비밀번호가 잘못되었습니다.",
        );
      }
    } catch (err) {
      log(err.toString());
      return ResponseModel(
        success: false,
        type: ResponseType.alert,
        title: "오류",
        content: err.toString(),
      );
    }
  }
}
