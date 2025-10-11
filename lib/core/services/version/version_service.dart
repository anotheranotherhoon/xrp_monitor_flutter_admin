import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xrp_monitor_flutter_admin/core/constants/api_path.dart';
import 'package:xrp_monitor_flutter_admin/core/services/base/models/api_response.dart';
import 'package:xrp_monitor_flutter_admin/core/services/base/models/response_model.dart';
import 'package:xrp_monitor_flutter_admin/core/services/keyword/models/keyword_create_request.dart';
import 'package:xrp_monitor_flutter_admin/core/services/base/models/response_exception.dart';
import 'package:xrp_monitor_flutter_admin/core/services/base/api_service.dart';
import 'package:xrp_monitor_flutter_admin/core/services/version/models/version_model.dart';

part 'version_service.g.dart';

@riverpod
class VersionService extends _$VersionService {

  late final ApiService _apiService = ref.read(apiServiceProvider.notifier);

  @override
  void build() {

  }

  Future<ResponseModel<List<Version>>> getAllVersion({String? platform}) async {
    try {
      String url = '${ApiPath.apiUrl}version/admin/versions';
      if (platform != null && platform.isNotEmpty) {
        url += '?platform=$platform';
      }
      
      final response = await _apiService.get(url: url);
      if (response.statusCode == 200) {
        final ApiResponse apiResponse = ApiResponse.fromJson(response.data!);
        final List<Version> data = [];
        for (final Map<String, dynamic> item in apiResponse.result?.list as List) {
          data.add(Version.fromJson(item));
        }
        return ResponseModel<List<Version>>(
            success: true,
            type: ResponseType.success,
            result: data,
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

  Future<ResponseModel<bool>> createVersion(CreateVersionParams request) async {
    try {
      final response = await _apiService.post(
        url: '${ApiPath.apiUrl}version/admin/versions',
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

  Future<ResponseModel<bool>> updateVersion(int id, CreateVersionParams request,) async {
    try{
      final response = await _apiService.put(
        url: '${ApiPath.apiUrl}version/admin/versions/$id',
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

  Future<ResponseModel<bool>> deleteVersion(int id) async {
    try{
      final response = await _apiService.delete(
          url: '${ApiPath.apiUrl}version/admin/versions/$id'
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