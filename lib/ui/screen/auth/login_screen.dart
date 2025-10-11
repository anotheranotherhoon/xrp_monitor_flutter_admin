import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import 'package:xrp_monitor_flutter_admin/constants/strings.dart';
import 'package:xrp_monitor_flutter_admin/service/authentication/authentication.dart';
import 'package:xrp_monitor_flutter_admin/service/authentication/models/login_request.dart';
import 'package:xrp_monitor_flutter_admin/utils/validators.dart';
import 'package:xrp_monitor_flutter_admin/widgets/auth/auth_button.dart';
import 'package:xrp_monitor_flutter_admin/widgets/auth/auth_text_field.dart';
import 'package:xrp_monitor_flutter_admin/widgets/base/widget_controller.dart';
import '../../../core/route/app_router.gr.dart';
part 'login_screen.controller.dart';

@RoutePage()
class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final LoginScreenController controller = useWidgetController(() => LoginScreenController(ref: ref), context);
    final formKey = useMemoized(() => GlobalKey<FormState>(), []);
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final isLoading = useState<bool>(false);
    final isPasswordVisible = useState<bool>(false);

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 320),
            child: Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'XRP Admin',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '관리자 로그인',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                // Email Field
                AuthTextField(
                  controller: emailController,
                  labelText: AppStrings.email,
                  hintText: AppStrings.emailPlaceholder,
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.emailValidator,
                ),

                const SizedBox(height: 16),

                // Password Field
                AuthTextField(
                  controller: passwordController,
                  labelText: AppStrings.password,
                  hintText: AppStrings.passwordPlaceholder,
                  prefixIcon: Icons.lock_outline,
                  obscureText: !isPasswordVisible.value,
                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordVisible.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      isPasswordVisible.value = !isPasswordVisible.value;
                    },
                  ),
                  validator: Validators.simplePasswordValidator,
                ),

                      const SizedBox(height: 16),

                      // 로그인 버튼
                      SizedBox(
                        height: 36,
                        child: AuthButton(
                          text: AppStrings.login,
                          isLoading: isLoading.value,
                          onPressed: () async {
                            if (formKey.currentState?.validate() ?? false) {
                              await controller.login(
                                context: context,
                                email: emailController.text,
                                password: passwordController.text,
                                isLoading: isLoading,
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}