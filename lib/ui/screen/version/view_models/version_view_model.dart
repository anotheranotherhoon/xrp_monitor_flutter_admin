import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xrp_monitor_flutter_admin/core/services/user/models/user_model.dart';
import 'package:xrp_monitor_flutter_admin/core/services/user/models/user_list_response.dart';
import 'package:xrp_monitor_flutter_admin/core/services/user/models/user_role.dart';
import 'package:xrp_monitor_flutter_admin/core/services/base/models/response_model.dart';
import 'package:xrp_monitor_flutter_admin/core/services/user/user_service.dart';
import 'package:xrp_monitor_flutter_admin/ui/screen/user/models/user_state.dart';

part 'version_view_model.g.dart';

@riverpod
class VersionViewModel extends _$VersionViewModel {
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
      log('VersionViewModel _fetchUsers error: $e');
      return UserState(
        users: const [],
        isLoading: false,
        error: e.toString(),
      );
    }
  }


}