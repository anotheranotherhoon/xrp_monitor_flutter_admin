// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:xrp_monitor_flutter_admin/core/constants/api_path.dart';

part 'popup_model.freezed.dart';
part 'popup_model.g.dart';

enum PopupActionType {
  @JsonValue('NONE')
  none,
  @JsonValue('EXTERNAL_LINK')
  externalLink,
}

extension PopupActionTypeExtension on PopupActionType {
  String get apiValue {
    switch (this) {
      case PopupActionType.none:
        return 'NONE';
      case PopupActionType.externalLink:
        return 'EXTERNAL_LINK';
    }
  }

  String get label {
    switch (this) {
      case PopupActionType.none:
        return '이동 없음';
      case PopupActionType.externalLink:
        return '외부 링크';
    }
  }
}

@freezed
abstract class PopupModel with _$PopupModel {
  const factory PopupModel({
    @JsonKey(name: 'poIdx') @Default(0) int key,
    @JsonKey(name: 'poTitle') @Default('') String title,
    @JsonKey(name: 'poImageUrl') @Default('') String imageUrl,
    @JsonKey(name: 'poDisplayOrder') @Default(1) int displayOrder,
    @JsonKey(name: 'poStartAt') String? startAt,
    @JsonKey(name: 'poEndAt') String? endAt,
    @JsonKey(name: 'poIsActive') @Default(true) bool isActive,
    @JsonKey(name: 'poActionType')
    @Default(PopupActionType.none)
    PopupActionType actionType,
    @JsonKey(name: 'poLinkUrl') String? linkUrl,
    @JsonKey(name: 'createdAt') @Default('') String createdAt,
    @JsonKey(name: 'updatedAt') @Default('') String updatedAt,
  }) = _PopupModel;

  const PopupModel._();

  String get resolvedImageUrl =>
      imageUrl.startsWith('http') ? imageUrl : '${ApiPath.apiDomain}$imageUrl';

  factory PopupModel.fromJson(Map<String, dynamic> json) =>
      _$PopupModelFromJson(json);
}
