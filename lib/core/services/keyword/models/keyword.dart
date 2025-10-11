import 'package:freezed_annotation/freezed_annotation.dart';
import 'keyword_type.dart';

part 'keyword.freezed.dart';
part 'keyword.g.dart';

@freezed
abstract class Keyword with _$Keyword {
  const factory Keyword({
    required int id,
    required String keyword,
    required String weight,
    required KeywordType type,
    required bool isActive,
    @JsonKey(fromJson: _dateTimeFromJson)
    required DateTime createdAt,
    @JsonKey(fromJson: _dateTimeFromJson)
    required DateTime updatedAt,
  }) = _Keyword;

  factory Keyword.fromJson(Map<String, dynamic> json) => _$KeywordFromJson(json);
}

DateTime _dateTimeFromJson(dynamic value) {
  if (value is String) {
    return DateTime.parse(value);
  }
  if (value is DateTime) {
    return value;
  }
  throw ArgumentError('Cannot parse DateTime from $value');
}