import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:xrp_monitor_flutter_admin/core/models/common/pagination.dart';
import 'user.dart';

part 'user_list_response.freezed.dart';
part 'user_list_response.g.dart';

@freezed
abstract class UserListResponse with _$UserListResponse {
  const factory UserListResponse({
    required List<User> users,
    Pagination? pageInfo,
  }) = _UserListResponse;

  factory UserListResponse.fromJson(Map<String, dynamic> json) => 
      _$UserListResponseFromJson(json);
}