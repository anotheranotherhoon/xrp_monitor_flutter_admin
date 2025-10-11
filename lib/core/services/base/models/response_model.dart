import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:xrp_monitor_flutter_admin/core/services/base/models/pagination.dart';

part 'response_model.freezed.dart';

enum ResponseType {
  @JsonValue('SUCCESS')
  success,
  @JsonValue('ALERT')
  alert,
  @JsonValue('CONFIRM')
  confirm,
  @JsonValue('TOAST')
  toast,
  @JsonValue('ETC')
  etc,
}

@freezed
abstract class ResponseModel<T extends Object> with _$ResponseModel<T> {
  factory ResponseModel({
    required bool success,
    required ResponseType type,
    @Default('') String title,
    @Default('') String content,
    int? code,
    dynamic cursorId,
    int? total,
    Pagination? page,
    T? result,
    nextCursor,
  }) = _ResponseModel<T>;
}
