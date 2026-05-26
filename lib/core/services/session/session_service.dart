import 'dart:developer';

import 'package:dio/dio.dart' hide ResponseType;
import 'package:xrp_monitor_flutter_admin/constants/strings.dart';
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
        final resultData = apiResponse.result?.data ?? response.data?['result'];
        final LoginResult loginUser = LoginResult.fromJson(resultData);
        return ResponseModel(
          success: true,
          type: ResponseType.success,
          result: loginUser,
        );
      } else {
        return _loginFailureResponse(response.data, response.statusCode);
      }
    } on DioException catch (err) {
      log(err.toString());
      return _loginFailureResponse(
        err.response?.data,
        err.response?.statusCode,
      );
    } catch (err) {
      log(err.toString());
      return ResponseModel(
        success: false,
        type: ResponseType.alert,
        title: AppStrings.loginFailed,
        content: AppStrings.loginErrorGeneral,
      );
    }
  }

  ResponseModel<LoginResult> _loginFailureResponse(
    dynamic data,
    int? statusCode,
  ) {
    String message = AppStrings.loginError;
    int? code = statusCode;

    if (data is Map<String, dynamic>) {
      message = data['message'] as String? ?? message;
      code = data['code'] as int? ?? code;
    } else if (data is Map) {
      final responseMessage = data['message'];
      final responseCode = data['code'];
      if (responseMessage is String && responseMessage.isNotEmpty) {
        message = responseMessage;
      }
      if (responseCode is int) {
        code = responseCode;
      }
    }

    return ResponseModel(
      success: false,
      type: ResponseType.alert,
      title: AppStrings.loginFailed,
      content: message,
      code: code,
    );
  }
}
