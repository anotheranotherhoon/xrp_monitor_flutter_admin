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