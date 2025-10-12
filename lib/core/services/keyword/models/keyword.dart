// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'keyword_type.dart';

part 'keyword.freezed.dart';
part 'keyword.g.dart';

@freezed
abstract class Keyword with _$Keyword {
  const factory Keyword({
    @JsonKey(name: 'keIdx') @Default(0) int key,
    @JsonKey(name: 'keKeyword') @Default("") String keyword,
    @JsonKey(name: 'keWeight') @Default("") String weight,
    @JsonKey(name: 'keType') @Default(KeywordType.IMPORTANT) KeywordType type,
    @JsonKey(name: 'keIsActive') @Default(false) bool isActive,
    @JsonKey(name: 'createdAt') @Default('') String createdAt,
    @JsonKey(name: 'updatedAt') @Default('') String updatedAt,
  }) = _Keyword;

  factory Keyword.fromJson(Map<String, dynamic> json) => _$KeywordFromJson(json);
}
