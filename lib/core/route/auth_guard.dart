import 'dart:async';
import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xrp_monitor_flutter_admin/service/authentication/authentication.dart';

class AuthGuard extends AutoRouteGuard {
  const AuthGuard({
    required this.ref,
    required this.fallback,
  });

  final Ref<dynamic> ref;
  final List<PageRouteInfo<dynamic>> fallback;

  @override
  Future<void> onNavigation(
      NavigationResolver resolver,
      StackRouter router,
      ) async {
    try {
      final session = await ref.read(authenticationProvider.future);
      if (session == null || session.accessToken == null) {
        resolver.next(false);
        unawaited(router.replaceAll(fallback));
        return;
      }

      resolver.next(true);
    } catch (err) {
      log(err.toString(), stackTrace: StackTrace.current);
      resolver.next(false);
      unawaited(router.replaceAll(fallback));
      return;
    }
  }
}