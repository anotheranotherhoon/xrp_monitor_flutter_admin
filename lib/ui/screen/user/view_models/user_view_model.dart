import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xrp_monitor_flutter_admin/core/services/user/models/user_model.dart';
import 'package:xrp_monitor_flutter_admin/core/services/user/models/user_role.dart';
import 'package:xrp_monitor_flutter_admin/core/services/user/models/user_create_request.dart';
import 'package:xrp_monitor_flutter_admin/core/services/base/models/response_model.dart';
import 'package:xrp_monitor_flutter_admin/core/services/user/user_service.dart';
import 'package:xrp_monitor_flutter_admin/ui/screen/user/models/user_state.dart';

part 'user_view_model.g.dart';

@riverpod
class UserViewModel extends _$UserViewModel {
  late final UserService _userService;

  @override
  FutureOr<UserState> build() async {
    _userService = ref.read(userServiceProvider.notifier);
    return await _fetchUsers();
  }

  Future<UserState> _fetchUsers({UserRole? role}) async {
    try {
      final ResponseModel<List<User>> response = await _userService.getUsers(
        role: role,
      );

      if (response.success && response.result != null) {
        return UserState(
          users: response.result!,
          pageInfo: response.page,
          isLoading: false,
        );
      } else {
        return UserState(
          users: const [],
          pageInfo: response.page,
          isLoading: false,
          error: response.content,
        );
      }
    } catch (e) {
      log('UserViewModel _fetchUsers error: $e');
      return UserState(users: const [], isLoading: false, error: e.toString());
    }
  }

  // 데이터 새로고침
  Future<void> reset({UserRole? role}) async {
    state = const AsyncValue.loading();
    try {
      UserState data = await _fetchUsers(role: role);
      state = AsyncValue.data(data);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  // USER 역할만 조회
  Future<void> fetchUsersByRole() async {
    await reset(role: UserRole.USER);
  }

  // 전체 사용자 조회
  Future<void> fetchAllUsers() async {
    await reset();
  }

  // 사용자 생성
  Future<ResponseModel<bool>> createUser(CreateUserRequest request) async {
    try {
      final response = await _userService.createUser(request);
      if (response.success) {
        // 성공시 데이터 새로고침
        await reset();
      }
      return response;
    } catch (e) {
      return ResponseModel<bool>(
        success: false,
        result: false,
        type: ResponseType.alert,
        title: "사용자 생성 오류",
        content: e.toString(),
      );
    }
  }

  // 사용자 정보 수정
  Future<ResponseModel<bool>> updateUser(
    int id,
    UpdateUserRequest request,
  ) async {
    try {
      final response = await _userService.updateUser(id, request);
      if (response.success) {
        // 성공시 데이터 새로고침
        await reset();
      }
      return response;
    } catch (e) {
      return ResponseModel<bool>(
        success: false,
        result: false,
        type: ResponseType.alert,
        title: "사용자 수정 오류",
        content: e.toString(),
      );
    }
  }

  // 사용자 삭제
  Future<ResponseModel<bool>> deleteUser(int id) async {
    try {
      final response = await _userService.deleteUser(id);
      if (response.success) {
        // 성공시 데이터 새로고침
        await reset();
      }
      return response;
    } catch (e) {
      return ResponseModel<bool>(
        success: false,
        result: false,
        type: ResponseType.alert,
        title: "사용자 삭제 오류",
        content: e.toString(),
      );
    }
  }

  Future<ResponseModel<bool>> sendNotification({
    required List<int> userIds,
    required String title,
    required String body,
  }) {
    return _userService.sendNotification(
      userIds: userIds,
      title: title,
      body: body,
    );
  }
}
