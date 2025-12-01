import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuth {
  static final Supabase _supabase = Supabase.instance;

  /// Sign up with email and password
  static Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.client.auth.signUp(
        email: email,
        password: password,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Sign in with email and password
  static Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Sign in with Google (OAuth)
  static Future<bool> signInWithGoogle() async {
    try {
      await _supabase.client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.nexacloth://login-callback/',
      );
      return true;
    } catch (e) {
      rethrow;
    }
  }

  /// Sign in with Apple (OAuth)
  static Future<bool> signInWithApple() async {
    try {
      await _supabase.client.auth.signInWithOAuth(
        OAuthProvider.apple,
        redirectTo: 'io.supabase.nexacloth://login-callback/',
      );
      return true;
    } catch (e) {
      rethrow;
    }
  }

  /// Sign out
  static Future<void> signOut() async {
    try {
      await _supabase.client.auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  /// Get current user
  static User? get currentUser => _supabase.client.auth.currentUser;

  /// Check if user is authenticated
  static bool get isAuthenticated => currentUser != null;

  /// Get auth state stream
  static Stream<AuthState> get authStateChanges =>
      _supabase.client.auth.onAuthStateChange;

  /// Reset password
  static Future<void> resetPassword(String email) async {
    try {
      await _supabase.client.auth.resetPasswordForEmail(
        email,
        redirectTo: 'io.supabase.nexacloth://reset-password/',
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Update password
  static Future<UserResponse> updatePassword(String newPassword) async {
    try {
      final response = await _supabase.client.auth.updateUser(
        UserAttributes(password: newPassword),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
