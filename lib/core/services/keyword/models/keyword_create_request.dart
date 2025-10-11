import 'package:freezed_annotation/freezed_annotation.dart';
import 'keyword_type.dart';

part 'keyword_create_request.freezed.dart';
part 'keyword_create_request.g.dart';

@freezed
abstract class KeywordCreateRequest with _$KeywordCreateRequest {
  const factory KeywordCreateRequest({
    required String keyword,
    required double weight,
    required KeywordType type,
  }) = _KeywordCreateRequest;

  factory KeywordCreateRequest.fromJson(Map<String, dynamic> json) => 
      _$KeywordCreateRequestFromJson(json);
}

