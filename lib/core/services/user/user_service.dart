import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xrp_monitor_flutter_admin/core/constants/api_path.dart';
import 'package:xrp_monitor_flutter_admin/core/services/base/models/api_response.dart';
import 'package:xrp_monitor_flutter_admin/core/services/user/models/user_model.dart';
import 'package:xrp_monitor_flutter_admin/core/services/user/models/user_role.dart';
import 'package:xrp_monitor_flutter_admin/core/services/user/models/user_create_request.dart';
import 'package:xrp_monitor_flutter_admin/core/services/base/models/response_exception.dart';
import 'package:xrp_monitor_flutter_admin/core/services/base/models/response_model.dart';
import 'package:xrp_monitor_flutter_admin/core/services/base/api_service.dart';

part 'user_service.g.dart';

@riverpod
class UserService extends _$UserService {
  late final ApiService _apiService = ref.read(apiServiceProvider.notifier);

  @override
  void build() {}

  Future<ResponseModel<List<User>>> getUsers({
    int page = 1,
    int perPage = 10,
    UserRole? role,
  }) async {
    try {
      String url = '${ApiPath.apiUrl}admin/users';

      final response = await _apiService.get(
        url: url,
        params: {
          'page': page,
          'perPage': perPage,
          'role': (role ?? UserRole.USER).value,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 304) {
        final ApiResponse apiResponse = ApiResponse.fromJson(response.data!);
        if (apiResponse.result?.list != null) {
          final List<User> data = [];
          for (final Map<String, dynamic> item
              in apiResponse.result?.list as List) {
            data.add(User.fromJson(item));
          }
          return ResponseModel(
            success: true,
            type: ResponseType.success,
            result: data,
            page: apiResponse.result!.page,
          );
        } else {
          return throw ResponseException(
            ResponseModel(success: false, type: ResponseType.alert),
          );
        }
      } else {
        return throw ResponseException(
          ResponseModel(
            success: false,
            title: '사용자 목록 조회 실패',
            type: ResponseType.alert,
          ),
        );
      }
    } catch (err) {
      return throw ResponseException(
        ResponseModel(
          success: false,
          type: ResponseType.alert,
          title: '사용자 목록 조회 실패',
          content: err.toString(),
        ),
      );
    }
  }

  Future<ResponseModel<bool>> createUser(CreateUserRequest request) async {
    try {
      final response = await _apiService.post(
        url: '${ApiPath.apiUrl}admin/users',
        params: request.toJson(),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ResponseModel<bool>(
          success: true,
          result: true,
          type: ResponseType.success,
        );
      } else {
        return ResponseModel<bool>(
          success: false,
          result: false,
          type: ResponseType.alert,
          title: "사용자 생성 실패",
          content: "사용자 생성에 실패했습니다.",
        );
      }
    } catch (err) {
      return ResponseModel<bool>(
        success: false,
        result: false,
        type: ResponseType.alert,
        title: "오류",
        content: err.toString(),
      );
    }
  }

  Future<ResponseModel<bool>> updateUser(
    int id,
    UpdateUserRequest request,
  ) async {
    try {
      final response = await _apiService.put(
        url: '${ApiPath.apiUrl}admin/users/$id',
        params: request.toJson(),
      );
      if (response.statusCode == 200) {
        return ResponseModel<bool>(
          success: true,
          result: true,
          type: ResponseType.success,
        );
      } else {
        return ResponseModel<bool>(
          success: false,
          result: false,
          type: ResponseType.alert,
          title: "사용자 수정 실패",
          content: "사용자 정보 수정에 실패했습니다.",
        );
      }
    } catch (err) {
      return ResponseModel<bool>(
        success: false,
        result: false,
        type: ResponseType.alert,
        title: "오류",
        content: err.toString(),
      );
    }
  }

  Future<ResponseModel<bool>> deleteUser(int id) async {
    try {
      final response = await _apiService.delete(
        url: '${ApiPath.apiUrl}admin/users/$id',
      );
      if (response.statusCode == 200) {
        return ResponseModel<bool>(
          success: true,
          result: true,
          type: ResponseType.success,
        );
      } else {
        return ResponseModel<bool>(
          success: false,
          result: false,
          type: ResponseType.alert,
          title: "사용자 삭제 실패",
          content: "사용자 삭제에 실패했습니다.",
        );
      }
    } catch (err) {
      return ResponseModel<bool>(
        success: false,
        result: false,
        type: ResponseType.alert,
        title: "오류",
        content: err.toString(),
      );
    }
  }
}
