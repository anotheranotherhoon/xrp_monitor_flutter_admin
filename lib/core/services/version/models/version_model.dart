// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'version_model.freezed.dart';
part 'version_model.g.dart';

@freezed
abstract class Version with _$Version {
  const factory Version({
    @JsonKey(name: 'veIdx') @Default(0) int key,
    @JsonKey(name: 'veVersion') @Default("") String version,
    @JsonKey(name: 'veMinimumVersion') @Default("") String minimumVersion,
    @JsonKey(name: 'vePlatform') @Default("") String platform,
    @JsonKey(name: 'veAppStatus') @Default(0) int appStatus,
    @JsonKey(name: 'veReleaseNotes') @Default("") String releaseNotes,

    @JsonKey(name: 'veDownloadUrl') @Default("") String downloadUrl,
    @JsonKey(name: 'veApiDomain') @Default("") String apiDomain,
    @JsonKey(name: 'veIsActive') @Default(false) bool isActive,

    @JsonKey(name: 'veReviewVersion') @Default("") String reviewVersion,
    @JsonKey(name: 'veShorebirdVersion') @Default("") String shorebirdVersion,
    @JsonKey(name: 'veDeploymentStatus') @Default("") String deploymentStatus,

    @JsonKey(name: 'createdAt') @Default("") String createdAt,
  }) = _Version;

  const Version._();

  factory Version.fromJson(Map<String, dynamic> json) => _$VersionFromJson(json);

}

@JsonSerializable(includeIfNull: false)
class CreateVersionParams {
  CreateVersionParams({
    required this.veVersion,
    required this.vePlatform,
    required this.veMinimumVersion,
    required this.veAppStatus,

    required this.veReleaseNotes,
    required this.veDownloadUrl,
    required this.veApiDomain,
    required this.veIsActive,


    required this.veReviewVersion,
    required this.veShorebirdVersion,
    required this.veDeploymentStatus,

  });

  String veVersion;
  String vePlatform;
  String veMinimumVersion;
  int veAppStatus;
  String veReleaseNotes;
  String veDownloadUrl;
  String veApiDomain;

  bool veIsActive;
  String veReviewVersion;
  String veShorebirdVersion;
  String veDeploymentStatus;




  factory CreateVersionParams.fromJson(Map<String, dynamic> json) => _$CreateVersionParamsFromJson(json);

  Map<String, dynamic> toJson() => _$CreateVersionParamsToJson(this);
}
