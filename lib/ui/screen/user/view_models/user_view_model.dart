import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xrp_monitor_flutter_admin/core/models/api/user/user.dart';
import 'package:xrp_monitor_flutter_admin/core/models/api/user/user_list_response.dart';
import 'package:xrp_monitor_flutter_admin/core/models/api/user/user_role.dart';
import 'package:xrp_monitor_flutter_admin/core/models/common/response_model.dart';
import 'package:xrp_monitor_flutter_admin/service/user/user_service.dart';
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
      final ResponseModel<List<User>> response = await _userService.getUsers();
      
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
          error: response.content ?? '사용자 목록을 불러올 수 없습니다.',
        );
      }
    } catch (e) {
      log('UserViewModel _fetchUsers error: $e');
      return UserState(
        users: const [],
        isLoading: false,
        error: e.toString(),
      );
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
}