import 'dart:typed_data';

import 'package:dio/dio.dart' hide ResponseType;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xrp_monitor_flutter_admin/core/constants/api_path.dart';
import 'package:xrp_monitor_flutter_admin/core/services/base/api_service.dart';
import 'package:xrp_monitor_flutter_admin/core/services/base/models/api_response.dart';
import 'package:xrp_monitor_flutter_admin/core/services/base/models/response_model.dart';
import 'package:xrp_monitor_flutter_admin/core/services/popup/models/popup_model.dart';

part 'popup_service.g.dart';

@riverpod
class PopupService extends _$PopupService {
  late final ApiService _apiService = ref.read(apiServiceProvider.notifier);

  @override
  void build() {}

  Future<ResponseModel<List<PopupModel>>> getPopups() async {
    final response = await _apiService.get(url: '${ApiPath.apiUrl}admin/popup');
    final apiResponse = ApiResponse.fromJson(response.data!);
    final items =
        (apiResponse.result?.list as List<dynamic>? ?? [])
            .map((item) => PopupModel.fromJson(item as Map<String, dynamic>))
            .toList();
    return ResponseModel(
      success: true,
      type: ResponseType.success,
      result: items,
    );
  }

  Future<void> createPopup({
    required String title,
    required int displayOrder,
    required String? startAt,
    required String? endAt,
    required bool isActive,
    required PopupActionType actionType,
    required String? linkUrl,
    required Uint8List imageBytes,
    required String imageName,
  }) async {
    await _apiService.postForm(
      url: '${ApiPath.apiUrl}admin/popup',
      formData: _formData(
        title: title,
        displayOrder: displayOrder,
        startAt: startAt,
        endAt: endAt,
        isActive: isActive,
        actionType: actionType,
        linkUrl: linkUrl,
        imageBytes: imageBytes,
        imageName: imageName,
      ),
    );
  }

  Future<void> updatePopup({
    required int id,
    required String title,
    required int displayOrder,
    required String? startAt,
    required String? endAt,
    required bool isActive,
    required PopupActionType actionType,
    required String? linkUrl,
    Uint8List? imageBytes,
    String? imageName,
  }) async {
    await _apiService.putForm(
      url: '${ApiPath.apiUrl}admin/popup/$id',
      formData: _formData(
        title: title,
        displayOrder: displayOrder,
        startAt: startAt,
        endAt: endAt,
        isActive: isActive,
        actionType: actionType,
        linkUrl: linkUrl,
        imageBytes: imageBytes,
        imageName: imageName,
      ),
    );
  }

  Future<void> deletePopup(int id) async {
    await _apiService.delete(url: '${ApiPath.apiUrl}admin/popup/$id');
  }

  Future<void> togglePopup(int id) async {
    await _apiService.put(url: '${ApiPath.apiUrl}admin/popup/$id/toggle');
  }

  FormData _formData({
    required String title,
    required int displayOrder,
    required String? startAt,
    required String? endAt,
    required bool isActive,
    required PopupActionType actionType,
    required String? linkUrl,
    Uint8List? imageBytes,
    String? imageName,
  }) {
    return FormData.fromMap({
      'poTitle': title,
      'poDisplayOrder': displayOrder.toString(),
      'poStartAt': startAt ?? '',
      'poEndAt': endAt ?? '',
      'poIsActive': isActive.toString(),
      'poActionType': actionType.apiValue,
      'poLinkUrl': linkUrl ?? '',
      if (imageBytes != null)
        'image': MultipartFile.fromBytes(
          imageBytes,
          filename: imageName ?? 'popup.jpg',
        ),
    });
  }
}
