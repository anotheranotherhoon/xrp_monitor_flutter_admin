import 'package:freezed_annotation/freezed_annotation.dart';
import 'keyword.dart';

part 'keyword_list_response.freezed.dart';
part 'keyword_list_response.g.dart';

@freezed
abstract class KeywordListResponse with _$KeywordListResponse {
  const factory KeywordListResponse({
    required List<Keyword> positiveKeywords,
    required List<Keyword> negativeKeywords,
    required List<Keyword> importantKeywords,
  }) = _KeywordListResponse;

  factory KeywordListResponse.fromJson(Map<String, dynamic> json) => 
      _$KeywordListResponseFromJson(json);
}