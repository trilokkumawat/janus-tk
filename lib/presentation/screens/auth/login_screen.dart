import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:janus/core/constants/app_text_style.dart';
import 'package:janus/core/constants/gaps.dart';
import 'package:janus/core/constants/routes.dart';
import 'package:janus/core/theme/app_theme.dart';
import 'package:janus/core/utils/validation.dart';
import 'package:janus/data/controller/login_controller.dart';
import 'package:janus/widgets/inputs/custom_text_field.dart';
import 'package:janus/widgets/animations/animated_background.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final success = await ref.read(loginControllerProvider.notifier).signIn();

    if (mounted && success) {
      context.go(AppRoutes.appState);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginControllerProvider);
    final loginController = ref.read(loginControllerProvider.notifier);

    return Scaffold(
      body: AnimatedBackground(
        particleCount: 60,
        particleSpeed: 0.8,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                        'Welcome Back',
                        style: AppTextStyle.h3.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                      .animate()
                      .fadeIn(
                        duration: const Duration(milliseconds: 600),
                        delay: const Duration(milliseconds: 100),
                      )
                      .slideY(
                        begin: -0.2,
                        end: 0,
                        duration: const Duration(milliseconds: 600),
                      ),
                  Text(
                        'Sign in to continue',
                        style: AppTextStyle.subtextMedium.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      )
                      .animate()
                      .fadeIn(
                        duration: const Duration(milliseconds: 600),
                        delay: const Duration(milliseconds: 200),
                      )
                      .slideY(
                        begin: -0.2,
                        end: 0,
                        duration: const Duration(milliseconds: 600),
                      ),
                  Gaps.h10,
                  Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white.withOpacity(0.95),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Email Field
                                  CustomTextField(
                                    controller: loginState.emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    labelText: 'Email',
                                    hintText: 'Enter your email',
                                    prefixIcon: const Icon(
                                      Icons.email_outlined,
                                    ),
                                    validator: (value) => validateEmail(value),
                                  ),
                                  Gaps.h10,

                                  // Password Field
                                  CustomTextField(
                                    controller: loginState.passwordController,
                                    obscureText: loginState.obscurePassword,
                                    textInputAction: TextInputAction.done,
                                    onFieldSubmitted: (_) => _handleLogin(),
                                    labelText: 'Password',
                                    hintText: 'Enter your password',
                                    prefixIcon: const Icon(Icons.lock_outlined),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        loginState.obscurePassword
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                      ),
                                      onPressed: loginController
                                          .togglePasswordVisibility,
                                    ),
                                    maxLength: 6,
                                    validator: (value) =>
                                        validatePassword(value),
                                  ),
                                  Gaps.h4,
                                  GestureDetector(
                                    onTap: () {
                                      context.push(AppRoutes.forgotPassword);
                                    },
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: Text(
                                        'Forgot Password?',
                                        style: AppTextStyle.bodyMedium.copyWith(
                                          color: AppColors.purple,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                          decorationColor: AppColors.purple,
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Gaps.h10,
                                  if (loginState.errorMessage != null)
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      margin: const EdgeInsets.only(bottom: 16),
                                      decoration: BoxDecoration(
                                        color: AppColors.highPriority
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: AppColors.highPriority
                                              .withOpacity(0.3),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.error_outline,
                                            color: AppColors.highPriority,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              loginState.errorMessage!,
                                              style: AppTextStyle.error,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  Gaps.h10,

                                  // Login Button
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: AppColors.primaryGradient,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ElevatedButton(
                                      onPressed: loginState.isLoading
                                          ? null
                                          : _handleLogin,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                      child: loginState.isLoading
                                          ? const SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                      Color
                                                    >(Colors.white),
                                              ),
                                            )
                                          : Text(
                                              'Sign In',
                                              style: AppTextStyle.buttonLarge,
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                      .animate()
                      .fadeIn(
                        duration: const Duration(milliseconds: 800),
                        delay: const Duration(milliseconds: 300),
                      )
                      .scale(
                        begin: const Offset(0.9, 0.9),
                        end: const Offset(1.0, 1.0),
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeOut,
                      ),
                  const SizedBox(height: 24),

                  // Register Link (outside card) with animation
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: AppTextStyle.subtextMedium.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.push(AppRoutes.register);
                        },
                        child: Text(
                          'Sign Up',
                          style: AppTextStyle.bodyMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 500),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
