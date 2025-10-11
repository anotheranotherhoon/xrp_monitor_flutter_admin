import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:xrp_monitor_flutter_admin/core/constants/api_path.dart';
import 'package:xrp_monitor_flutter_admin/core/services/base/auth_interceptor.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xrp_monitor_flutter_admin/service/storage/local_storage_service.dart';

part 'api_service.g.dart';

@riverpod
class ApiService extends _$ApiService {
  late final Dio _dio;

  @override
  void build() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiPath.apiDomain,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
    _dio.interceptors.add(AuthInterceptor(ref: ref));
  }

  String _makePathParameter({
    required String url,
    required Map<String, dynamic>? params,
  }) {
    if (params != null) {
      final queryString = params.entries.map((entry) {
        final key = entry.key;
        final value = entry.value;
        if (value is List) {
          return value.map((item) => '$key[]=$item').join('&');
        } else {
          return '$key=${value.toString()}';
        }
      }).join('&');

      if (queryString.isNotEmpty) {
        return '$url?$queryString';
      } else {
        return url;
      }
    } else {
      return url;
    }
  }

  Future<Response<Map<String, dynamic>>> get({
    required String url,
    Map<String, dynamic>? params,
    isTokenLess = false,
  }) async {
    late final requestUrlString = _makePathParameter(url: url, params: params);
    final token = LocalStorageService.instance.getAccessToken();
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        requestUrlString,
        options: Options(
          headers: {
            if (!isTokenLess && token != null) 'Authorization': 'Bearer $token',
          },
          extra: {
            'isTokenLess': isTokenLess, // or false
          },
        ),
      );
      return response;
    } catch (err) {
      if (err is DioException) {
        return throw err;
      }
      log(err.toString());
      return throw Exception(err);
    }
  }

  Future<Response<Map<String, dynamic>>> post({
    required String url,
    Map<String, dynamic>? params,
  }) async {
    try {
      final token = LocalStorageService.instance.getAccessToken();
      final response = await _dio.post<Map<String, dynamic>>(
        url,
        data: params,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );
      return response;
    } catch (err) {
      if (err is DioException) {
        return throw err;
      }
      log(err.toString());
      return throw Exception(err);
    }
  }


  Future<Response<Map<String, dynamic>>> patch({
    required String url,
    Map<String, dynamic>? params,
  }) async {
    try {
      final token = LocalStorageService.instance.getAccessToken();
      final response = await _dio.patch<Map<String, dynamic>>(
        url,
        data: params,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );
      return response;
    } catch (err) {
      if (err is DioException) {
        return throw err;
      }
      log(err.toString());
      return throw Exception(err);
    }
  }

  Future<Response<Map<String, dynamic>>> delete({
    required String url,
    Map<String, dynamic>? params,
  }) async {
    try {
      final token = LocalStorageService.instance.getAccessToken();
      final response = await _dio.delete<Map<String, dynamic>>(
        url,
        data: params,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );
      return response;
    } catch (err) {
      if (err is DioException) {
        return throw err;
      }
      log(err.toString());
      return throw Exception(err);
    }
  }

  Future<Response<Map<String, dynamic>>> put({
    required String url,
    Map<String, dynamic>? params,
  }) async {
    try {
      final token = LocalStorageService.instance.getAccessToken();
      final response = await _dio.put<Map<String, dynamic>>(
        url,
        data: params,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );
      return response;
    } catch (err) {
      if (err is DioException) {
        return throw err;
      }
      log(err.toString());
      return throw Exception(err);
    }
  }
}
