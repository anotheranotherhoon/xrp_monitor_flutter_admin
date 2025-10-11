import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:xrp_monitor_flutter_admin/core/models/common/pagination.dart';
import '../../../../core/models/api/user/user.dart';

part 'user_state.freezed.dart';

@freezed
abstract class UserState with _$UserState {
  const factory UserState({
    @Default([]) List<User> users,
    Pagination? pageInfo,
    @Default(false) bool isLoading,
    String? error,
  }) = _UserState;
}