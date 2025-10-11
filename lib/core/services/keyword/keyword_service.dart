import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xrp_monitor_flutter_admin/core/constants/api_path.dart';
import 'package:xrp_monitor_flutter_admin/core/services/base/models/api_response.dart';
import 'package:xrp_monitor_flutter_admin/core/services/base/models/response_model.dart';
import 'package:xrp_monitor_flutter_admin/core/services/keyword/models/keyword_create_request.dart';
import 'package:xrp_monitor_flutter_admin/core/services/keyword/models/keyword_list_response.dart';
import 'package:xrp_monitor_flutter_admin/core/services/keyword/models/keyword_update_request.dart';
import 'package:xrp_monitor_flutter_admin/core/services/base/models/response_exception.dart';
import 'package:xrp_monitor_flutter_admin/core/services/base/api_service.dart';

part 'keyword_service.g.dart';

@riverpod
class KeywordService extends _$KeywordService {

  late final ApiService _apiService = ref.read(apiServiceProvider.notifier);

  @override
  void build() {

  }

  Future<ResponseModel<KeywordListResponse>> getAllKeywords() async {
    try {
      final response = await _apiService.get(
          url: '${ApiPath.apiUrl}keyword/admin/all'
      );
      if (response.statusCode == 200) {
        final ApiResponse apiResponse = ApiResponse.fromJson(response.data!);
        KeywordListResponse? keywordData;
        if(apiResponse.result?.data != null){
          keywordData = KeywordListResponse.fromJson(apiResponse.result!.data as Map<String, dynamic>);
        }else{
          keywordData = KeywordListResponse(
            positiveKeywords: [],
            negativeKeywords: [],
            importantKeywords: [],
          );
        }

        return ResponseModel<KeywordListResponse>(
            success: true,
            type: ResponseType.success,
            result: keywordData,
        );
      } else {
        return ResponseModel(success: false, type: ResponseType.alert);
      }
    } catch (err) {
      return throw
      ResponseException(
          ResponseModel(
            success: false,
            type: ResponseType.alert,
            title: '뉴스 정보 조회 실패',
          )
      );
    }
  }

  Future<ResponseModel<bool>> createKeyword(KeywordCreateRequest request) async {
   try {
     final response = await _apiService.post(
       url: '${ApiPath.apiUrl}keyword/admin',
       params: request.toJson(),
     );
     if (response.statusCode == 201) {
       final ApiResponse apiResponse = ApiResponse.fromJson(response.data!);

       return ResponseModel(
         success: true,
         type: ResponseType.success,
         result: true,
       );
     } else {
       return ResponseModel(
         success: false,
         type: ResponseType.alert,
         title: "키워드 생성 실패",
         content: "키워드 생성에 실패했습니다.",
         result: false,
       );
     }

   }catch(err){
     return ResponseModel(
       success: false,
       type: ResponseType.alert,
       title: "오류",
       content: err.toString(),
       result: false,
     );
   }
  }

  Future<ResponseModel<bool>> updateKeyword(
      int id,
      KeywordUpdateRequest request,
      ) async {
    try{
      final response = await _apiService.put(
        url: '${ApiPath.apiUrl}keyword/admin/$id',
        params: request.toJson(),
      );
      if (response.statusCode == 200) {
        final ApiResponse apiResponse = ApiResponse.fromJson(response.data!);

        return ResponseModel(
          success: true,
          type: ResponseType.success,
          result: true,
        );
      } else {
        return ResponseModel(
          success: false,
          type: ResponseType.alert,
          title: "키워드 수정 실패",
          content: "키워드 수정에 실패했습니다.",
          result: false,
        );
      }
    }catch(err){
      return ResponseModel(
        success: false,
        type: ResponseType.alert,
        title: "오류",
        content: err.toString(),
        result: false,
      );
    }

  }

  Future<ResponseModel<bool>> deleteKeyword(int id) async {
    try{
      final response = await _apiService.delete(
          url: '${ApiPath.apiUrl}keyword/admin/$id'
      );
      if (response.statusCode == 200) {
        final ApiResponse apiResponse = ApiResponse.fromJson(response.data!);

        return ResponseModel(
          success: true,
          type: ResponseType.success,
          result: true,
        );
      } else {
        return ResponseModel(
          success: false,
          type: ResponseType.alert,
          title: "키워드 삭제 실패",
          content: "키워드 삭제에 실패했습니다.",
          result: false,
        );
      }
    }catch(err){
      return ResponseModel(
        success: false,
        type: ResponseType.alert,
        title: "오류",
        content: err.toString(),
        result: false,
      );
    }

  }


}