import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:xrp_monitor_flutter_admin/core/services/base/models/pagination.dart';
import '../../../../core/services/user/models/user_model.dart';

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