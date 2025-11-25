import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../services/auth_service.dart';

/// State class for login screen
class LoginState {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isLoading;
  final bool obscurePassword;
  final String? errorMessage;

  LoginState({
    required this.emailController,
    required this.passwordController,
    this.isLoading = false,
    this.obscurePassword = true,
    this.errorMessage,
  });

  LoginState copyWith({
    TextEditingController? emailController,
    TextEditingController? passwordController,
    bool? isLoading,
    bool? obscurePassword,
    String? errorMessage,
    bool clearError = false,
  }) {
    return LoginState(
      emailController: emailController ?? this.emailController,
      passwordController: passwordController ?? this.passwordController,
      isLoading: isLoading ?? this.isLoading,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

/// Login controller using Riverpod StateNotifier
class LoginController extends StateNotifier<LoginState> {
  LoginController()
    : super(
        LoginState(
          emailController: TextEditingController(),
          passwordController: TextEditingController(),
        ),
      );

  /// Toggle password visibility
  void togglePasswordVisibility() {
    state = state.copyWith(obscurePassword: !state.obscurePassword);
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(clearError: true);
  }

  /// Sign in with email and password
  Future<bool> signIn() async {
    final email = state.emailController.text.trim();
    final password = state.passwordController.text;

    // Start loading
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      await SupabaseAuth.signInWithEmail(email: email, password: password);

      // Success
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      // Error occurred
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      state = state.copyWith(errorMessage: errorMessage, isLoading: false);
      return false;
    }
  }

  Future<bool> signUp() async {
    final email = state.emailController.text.trim();
    final password = state.passwordController.text;

    // Start loading
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      await SupabaseAuth.signUpWithEmail(email: email, password: password);

      // Success
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      // Error occurred
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      state = state.copyWith(errorMessage: errorMessage, isLoading: false);
      return false;
    }
  }

  @override
  void dispose() {
    state.emailController.dispose();
    state.passwordController.dispose();
    super.dispose();
  }
}

/// Provider for login controller
final loginControllerProvider =
    StateNotifierProvider.autoDispose<LoginController, LoginState>((ref) {
      return LoginController();
    });
