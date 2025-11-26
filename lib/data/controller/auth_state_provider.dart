import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';

/// Auth state model
class AuthState {
  final User? user;
  final bool isAuthenticated;
  final bool isLoading;
  final Session? session;

  const AuthState({
    this.user,
    this.isAuthenticated = false,
    this.isLoading = true,
    this.session,
  });

  AuthState copyWith({
    User? user,
    bool? isAuthenticated,
    bool? isLoading,
    Session? session,
  }) {
    return AuthState(
      user: user ?? this.user,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      session: session ?? this.session,
    );
  }
}

/// Auth state notifier that listens to Supabase auth changes in real-time
class AuthStateNotifier extends StateNotifier<AuthState> {
  StreamSubscription? _authSubscription;

  AuthStateNotifier() : super(const AuthState(isLoading: true)) {
    _initializeAuth();
    _listenToAuthChanges();
  }

  /// Initialize auth state from current session
  void _initializeAuth() {
    final client = SupabaseService.client;
    final currentUser = client.auth.currentUser;
    final currentSession = client.auth.currentSession;

    state = AuthState(
      user: currentUser,
      isAuthenticated: currentUser != null,
      isLoading: false,
      session: currentSession,
    );
  }

  /// Listen to real-time auth state changes
  void _listenToAuthChanges() {
    final client = SupabaseService.client;

    _authSubscription = client.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;

      switch (event) {
        case AuthChangeEvent.initialSession:
          state = AuthState(
            user: session?.user,
            isAuthenticated: session?.user != null,
            isLoading: false,
            session: session,
          );
          break;
        case AuthChangeEvent.signedIn:
          state = AuthState(
            user: session?.user,
            isAuthenticated: true,
            isLoading: false,
            session: session,
          );
          break;
        case AuthChangeEvent.signedOut:
          state = const AuthState(
            user: null,
            isAuthenticated: false,
            isLoading: false,
            session: null,
          );
          break;
        case AuthChangeEvent.tokenRefreshed:
          state = AuthState(
            user: session?.user,
            isAuthenticated: session?.user != null,
            isLoading: false,
            session: session,
          );
          break;
        case AuthChangeEvent.userUpdated:
          state = AuthState(
            user: session?.user,
            isAuthenticated: session?.user != null,
            isLoading: false,
            session: session,
          );
          break;
        case AuthChangeEvent.passwordRecovery:
        case AuthChangeEvent.userDeleted:
        case AuthChangeEvent.mfaChallengeVerified:
          state = const AuthState(
            user: null,
            isAuthenticated: false,
            isLoading: false,
            session: null,
          );
          break;
      }
    });
  }

  /// Refresh auth state manually
  void refresh() {
    _initializeAuth();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}

/// Global auth state provider
final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((
  ref,
) {
  return AuthStateNotifier();
});
