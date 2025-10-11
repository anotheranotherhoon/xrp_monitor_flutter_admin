import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:xrp_monitor_flutter_admin/core/constants/api_path.dart';
import 'package:xrp_monitor_flutter_admin/core/route/app_router.dart';
import 'package:xrp_monitor_flutter_admin/core/route/app_router.gr.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xrp_monitor_flutter_admin/service/authentication/authentication.dart';
import 'package:xrp_monitor_flutter_admin/service/storage/local_storage_service.dart';


class AuthInterceptor extends Interceptor {
  const AuthInterceptor({
    required this.ref,
  });

  final Ref ref;

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      final isTokenLess = options.extra['isTokenLess'] == true;
      if (!isTokenLess) {
        final accessToken = ref.read(authenticationProvider).value?.accessToken;
        if (accessToken != null && accessToken.token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer ${accessToken.token}';
        }
      }
      super.onRequest(options, handler);
    } catch (err) {
      log(err.toString(), stackTrace: StackTrace.current);
      super.onRequest(options, handler);
    }
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final String? refreshToken = ref.read(authenticationProvider).value?.refreshToken?.token;
      if(refreshToken != null){
        final Dio refreshDio = Dio(BaseOptions(baseUrl: ApiPath.apiDomain));
        final Response<dynamic> response = await refreshDio.post(
          'auth//refresh',
          data: {'refreshToken': refreshToken},
        );
        if(response.statusCode == 200){
          final String newAccessToken = response.data['result']['data']['accessToken'];
          final String newRefreshToken = response.data['result']['data']['refreshToken'];

          await LocalStorageService.instance.setUserToken(newAccessToken);
          await LocalStorageService.instance.setUserRefreshToken(newRefreshToken);

          ref.read(authenticationProvider.notifier).updateToken(newAccessToken, newRefreshToken);

          final originalRequest = err.requestOptions;
          final retryDio = Dio(BaseOptions(
            baseUrl: ApiPath.apiDomain,
            headers: {...originalRequest.headers},
          ));

          originalRequest.headers['Authorization'] = 'Bearer $newAccessToken';

          try {
            final retryResponse = await retryDio.fetch(originalRequest);
            return handler.resolve(retryResponse);
          } on DioException catch (retryError) {
            return handler.reject(retryError);
          }
        }
      }else{
        final router = ref.read(appRouterProvider);
        unawaited(router.replaceAll(
            [
              const LoginRoute()
            ]));

      }


    }
    super.onError(err, handler);
  }
}
