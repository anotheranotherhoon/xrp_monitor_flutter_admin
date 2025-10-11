import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xrp_monitor_flutter_admin/core/services/base/models/response_model.dart';
import 'package:xrp_monitor_flutter_admin/core/services/version/models/version_model.dart';
import 'package:xrp_monitor_flutter_admin/core/services/version/version_service.dart';
import 'package:xrp_monitor_flutter_admin/ui/screen/version/models/version_state.dart';

part 'version_view_model.g.dart';

@riverpod
class VersionViewModel extends _$VersionViewModel {
  late final VersionService _versionService;

  @override
  FutureOr<VersionState> build() async {
    _versionService = ref.read(versionServiceProvider.notifier);
    return await _fetchVersion();
  }

  Future<VersionState> _fetchVersion({String? platform}) async {
    try {
      final ResponseModel<List<Version>> response = await _versionService.getAllVersion(platform: platform);

      if (response.success && response.result != null) {
        return VersionState(
          version: response.result!,
          isLoading: false,
        );
      } else {
        return VersionState(
          version: const [],
          isLoading: false,
          error: '버전 목록을 불러올 수 없습니다.',
        );
      }
    } catch (e) {
      log('VersionViewModel _fetchVersion error: $e');
      return VersionState(
        version: const [],
        isLoading: false,
        error: e.toString(),
      );
    }
  }
  
  Future<void> fetchVersionsByPlatform(String? platform) async {
    state = const AsyncValue.loading();
    
    try {
      final newState = await _fetchVersion(platform: platform);
      state = AsyncValue.data(newState);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }


  Future<ResponseModel<bool>> createVersion(CreateVersionParams request) async {
    try {
      final response = await _versionService.createVersion(request);
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

  Future<ResponseModel<bool>> updateVersion(int id,CreateVersionParams request) async {
    try {
      final response = await _versionService.updateVersion(id,request);
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

  Future<ResponseModel<bool>> deleteVersion(int id) async {
    try {
      final response = await _versionService.deleteVersion(id);
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