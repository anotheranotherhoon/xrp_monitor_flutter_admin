part of 'login_screen.dart';

class LoginScreenController extends ConsumerWidgetController<LoginScreen> {
  LoginScreenController({required super.ref});

  @override
  void build(BuildContext context) {}

  Future<void> login({
    required BuildContext context,
    required String email,
    required String password,
    required ValueNotifier<bool> isLoading,
  }) async {
    isLoading.value = true;

    try {
      final request = LoginRequest(email: email, password: password);

      final result = await ref
          .read(authenticationProvider.notifier)
          .login(request);

      if (result.success) {
        // 로그인 성공시 토스트 없이 바로 화면 전환 (화면 전환 자체가 성공 피드백)
        if (context.mounted) {
          context.router.replaceAll([const DashboardRoute()]);
        }
      } else {
        if (context.mounted) {
          await _showLoginFailureDialog(
            context: context,
            message:
                result.content.isNotEmpty
                    ? result.content
                    : AppStrings.loginErrorGeneral,
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        await _showLoginFailureDialog(
          context: context,
          message: AppStrings.loginErrorGeneral,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _showLoginFailureDialog({
    required BuildContext context,
    required String message,
  }) {
    return showDialog<void>(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
            actionsPadding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
            title: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEE2E2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.error_outline,
                    color: Color(0xFFDC2626),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    AppStrings.loginFailed,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111827),
                    ),
                  ),
                ),
              ],
            ),
            content: Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                height: 1.45,
                color: Color(0xFF4B5563),
              ),
            ),
            actions: [
              SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF111827),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    AppStrings.confirm,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
    );
  }
}
