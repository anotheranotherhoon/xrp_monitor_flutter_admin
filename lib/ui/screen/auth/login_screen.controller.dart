part of 'login_screen.dart';

class LoginScreenController extends ConsumerWidgetController<LoginScreen> {
  LoginScreenController ({
    required super.ref
  });

  @override
  void build(BuildContext context) {

  }



  Future<void> login({
    required BuildContext context,
    required String email,
    required String password,
    required ValueNotifier<bool> isLoading,
  }) async {
    isLoading.value = true;

    try {
      final request = LoginRequest(
        email: email,
        password: password,
      );

      final result = await ref.read(authenticationProvider.notifier).login(request);

      if (result.success) {
        // 로그인 성공시 토스트 없이 바로 화면 전환 (화면 전환 자체가 성공 피드백)
        if (context.mounted) {
          context.router.replaceAll([const DashboardLayout()]);
        }
      } else {
        // _showSafeToast(context, AppStrings.loginFailure);
      }
    } catch (e) {
      // _showSafeToast(context, AppStrings.errorWithDetails(e.toString()));
    } finally {
      isLoading.value = false;
    }
  }
}
