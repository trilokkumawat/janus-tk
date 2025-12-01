import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user/user_model.dart';
import '../../data/services/supabase_service.dart';

/// Provider that fetches user data from the users table
/// Automatically updates when auth state changes
final userDataProvider = StreamProvider<UserModel?>((ref) async* {
  // Fetch initial user data if user is already logged in
  final initialUser = SupabaseService.instance.currentUser;
  if (initialUser != null) {
    try {
      final response = await SupabaseService.client
          .from('users')
          .select()
          .eq('id', initialUser.id)
          .single();

      yield UserModel.fromJson(Map<String, dynamic>.from(response));
    } catch (e) {
      yield null;
    }
  } else {
    yield null;
  }

  // Listen to auth state changes
  await for (final authState in SupabaseService.client.auth.onAuthStateChange) {
    final user = authState.session?.user;

    if (user == null) {
      // User is not logged in
      yield null;
      continue;
    }

    try {
      // Fetch user data from the users table
      final response = await SupabaseService.client
          .from('users')
          .select()
          .eq('id', user.id)
          .single();

      yield UserModel.fromJson(Map<String, dynamic>.from(response));
    } catch (e) {
      // If there's an error, yield null
      yield null;
    }
  }
});

/// Provider that provides the current user data synchronously
/// Returns null if user is not logged in or data is not loaded
final currentUserDataProvider = Provider<UserModel?>((ref) {
  final userDataAsync = ref.watch(userDataProvider);
  return userDataAsync.when(
    data: (user) => user,
    loading: () => null,
    error: (_, __) => null,
  );
});
