// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'version_model.freezed.dart';
part 'version_model.g.dart';

@freezed
abstract class Version with _$Version {
  const factory Version({
    @JsonKey(name: 'id') @Default(0) int id,
    @JsonKey(name: 'version') @Default('') String originalLink,
    @JsonKey(name: 'platform') @Default('') String platform,
    @JsonKey(name: 'appStatus') @Default(0) int appStatus,
    @JsonKey(name: 'releaseNotes') @Default('') String releaseNotes,

    @JsonKey(name: 'downloadUrl') @Default('') String downloadUrl,
    @JsonKey(name: 'apiDomain') @Default('') String apiDomain,
    @JsonKey(name: 'isActive') @Default(false) bool isActive,
    @JsonKey(name: 'createdAt') @Default('') String createdAt,


  }) = _Version;

  const Version._();

  factory Version.fromJson(Map<String, dynamic> json) => _$VersionFromJson(json);

}
