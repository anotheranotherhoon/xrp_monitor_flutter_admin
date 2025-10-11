// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination.freezed.dart';
part 'pagination.g.dart';

@freezed
abstract class Pagination with _$Pagination {
  const factory Pagination({
    @JsonKey(name: 'total') required int total,
    @JsonKey(name: 'perPage') required int perPage,
    @JsonKey(name: 'currentPage') required int currentPage,
    @JsonKey(name: 'lastPage') required int lastPage,
  }) = _Pagination;
  factory Pagination.fromJson(Map<String, dynamic> json) =>
      _$PaginationFromJson(json);
}
