import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_router.gr.dart';
import 'auth_guard.dart';

class AppReevaluateNotifier with ChangeNotifier {
  void refresh() {
    notifyListeners();
  }
}

AppRouter? _appRouter;

AppRouter? getAppRouterSafe() => _appRouter;
AppRouter getAppRouter() => _appRouter!;

final appRouterProvider = Provider<AppRouter>((ref) {
  _appRouter ??= AppRouter(ref);
  return _appRouter!;
});

final appReevaluateNotifierProvider =
ChangeNotifierProvider((ref) => AppReevaluateNotifier());

/// ----------------------------
/// AppRouter
/// ----------------------------
///
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  AppRouter(this.ref);

  final Ref ref;

  List<AutoRouteGuard> get authGuards => [
    AuthGuard(ref: ref, fallback: [
      const LoginRoute()
    ]
    ),
  ];

  @override
  List<AutoRoute> get routes => [
    // Authentication routes
    AutoRoute(
      page: LoginRoute.page,
      path: '/login',
      initial: true
    ),

    // Dashboard routes
    AutoRoute(
      page: DashboardLayout.page,
      path: '/dashboard',
      guards: authGuards,
    ),

  ];
}
