import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xrp_monitor_flutter_admin/core/models/api/keyword/keyword_create_request.dart';
import 'package:xrp_monitor_flutter_admin/core/models/api/keyword/keyword_list_response.dart';
import 'package:xrp_monitor_flutter_admin/core/models/api/keyword/keyword_update_request.dart';
import 'package:xrp_monitor_flutter_admin/core/models/common/response_model.dart';
import 'package:xrp_monitor_flutter_admin/service/keyword/keyword_service.dart';
import 'package:xrp_monitor_flutter_admin/ui/screen/keyword/models/keyword_state.dart';


part 'keyword_view_model.g.dart';



@riverpod
class KeywordViewModel extends _$KeywordViewModel {
  late final KeywordService _keywordService;

  @override
  FutureOr<KeywordState> build() async {
    _keywordService = ref.read(keywordServiceProvider.notifier);
    return await _fetchKeyword();
  }


  Future<KeywordState> _fetchKeyword() async {
    final ResponseModel<KeywordListResponse> response = await _keywordService.getAllKeywords();
    return KeywordState(
        positiveKeywords: response.result?.positiveKeywords ?? [],
        negativeKeywords: response.result?.negativeKeywords ?? [],
        importantKeywords: response.result?.importantKeywords ?? [],
    );
  }

  void reset() async{
    KeywordState data = await _fetchKeyword();
    state = AsyncValue.data(data);
  }


  Future<ResponseModel<bool>> createKeyword(KeywordCreateRequest request) async {
    try {
      final response = await _keywordService.createKeyword(request);
      if (response.success && response.result != null) {
        return ResponseModel<bool>(
          success: true,
          result: true,
          type: ResponseType.success,
        );
      }else{
        return ResponseModel<bool>(
          success: false,
          result: false,
          type: ResponseType.success,
        );
      }
    } catch (e) {
      return ResponseModel<bool>(
        success: false,
        type: ResponseType.alert,
      );
    }
  }

  Future<ResponseModel<bool>> updateKeyword(int id,KeywordUpdateRequest request) async {
    try {
      final response = await _keywordService.updateKeyword(id,request);
      if (response.success && response.result != null) {
        return ResponseModel<bool>(
          success: true,
          result: true,
          type: ResponseType.success,
        );
      }else{
        return ResponseModel<bool>(
          success: false,
          result: false,
          type: ResponseType.success,
        );
      }
    } catch (e) {
      return ResponseModel<bool>(
        success: false,
        type: ResponseType.alert,
      );
    }
  }

  Future<ResponseModel<bool>> deleteKeyword(int id) async {
    try {
      final response = await _keywordService.deleteKeyword(id);
      if (response.success && response.result != null) {
        return ResponseModel<bool>(
          success: true,
          result: true,
          type: ResponseType.success,
        );
      }else{
        return ResponseModel<bool>(
          success: false,
          result: false,
          type: ResponseType.success,
        );
      }
    } catch (e) {
      return ResponseModel<bool>(
        success: false,
        type: ResponseType.alert,
      );
    }
  }

}
