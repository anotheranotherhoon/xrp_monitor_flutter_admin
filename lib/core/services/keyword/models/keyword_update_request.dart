import 'package:freezed_annotation/freezed_annotation.dart';
import 'keyword_type.dart';

part 'keyword_update_request.freezed.dart';
part 'keyword_update_request.g.dart';

@freezed
abstract class KeywordUpdateRequest with _$KeywordUpdateRequest {
  const factory KeywordUpdateRequest({
    required String keKeyword,
    required double keWeight,
    required KeywordType keType,
    required bool keIsActive,
  }) = _KeywordUpdateRequest;

  factory KeywordUpdateRequest.fromJson(Map<String, dynamic> json) => 
      _$KeywordUpdateRequestFromJson(json);
}