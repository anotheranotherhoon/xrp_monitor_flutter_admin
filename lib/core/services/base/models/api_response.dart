// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:xrp_monitor_flutter_admin/core/services/base/models/pagination.dart';


part 'api_response.freezed.dart';

part 'api_response.g.dart';


@freezed
abstract class ApiResponse with _$ApiResponse {
  const factory ApiResponse({
    @JsonKey(name: 'message') required String message,
    @JsonKey(name: 'code') required int code,
    @JsonKey(name: 'success') required bool success,
    @JsonKey(name: 'result') ApiResult? result,
  }) = _ApiResponse;

  factory ApiResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiResponseFromJson(json);
}

@freezed
abstract class ApiResult with _$ApiResult {
  const factory ApiResult({
    @JsonKey(name: 'page') Pagination? page,
    @JsonKey(name: 'total') int? total,
    @JsonKey(name: 'nextCursor') dynamic nextCursor,
    @JsonKey(name: 'list') dynamic list,
    @JsonKey(name: 'data') dynamic data
  }) = _ApiResult;


  factory ApiResult.fromJson(Map<String, dynamic> json) =>
      _$ApiResultFromJson(json);
}