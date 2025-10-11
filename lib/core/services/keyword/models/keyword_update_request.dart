import 'package:freezed_annotation/freezed_annotation.dart';
import 'keyword_type.dart';

part 'keyword_update_request.freezed.dart';
part 'keyword_update_request.g.dart';

@freezed
abstract class KeywordUpdateRequest with _$KeywordUpdateRequest {
  const factory KeywordUpdateRequest({
    required String keyword,
    required double weight,
    required KeywordType type,
    required bool isActive,
  }) = _KeywordUpdateRequest;

  factory KeywordUpdateRequest.fromJson(Map<String, dynamic> json) => 
      _$KeywordUpdateRequestFromJson(json);
}