import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants/supabase_constants.dart';

/// Supabase service for managing database connections and operations
///
/// This service provides a singleton instance of the Supabase client
/// and handles initialization and configuration
class SupabaseService {
  static SupabaseService? _instance;
  static SupabaseClient? _client;

  SupabaseService._();

  /// Get singleton instance of SupabaseService
  static SupabaseService get instance {
    _instance ??= SupabaseService._();
    return _instance!;
  }

  /// Initialize Supabase with configuration
  ///
  /// Call this method in your main.dart before runApp()
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: SupabaseConstants.supabaseUrl,
      anonKey: SupabaseConstants.supabaseAnonKey,
      debug: false, // Set to true for development
    );
    _client = Supabase.instance.client;
  }

  /// Get the Supabase client instance
  ///
  /// Returns the initialized Supabase client
  /// Throws an error if Supabase is not initialized
  static SupabaseClient get client {
    if (_client == null) {
      throw Exception(
        'Supabase not initialized. Call SupabaseService.initialize() first.',
      );
    }
    return _client!;
  }

  /// Get the current authenticated user
  User? get currentUser => client.auth.currentUser;

  /// Check if user is authenticated
  bool get isAuthenticated => currentUser != null;

  /// Sign out the current user
  Future<void> signOut() async {
    await client.auth.signOut();
  }

  /// Dispose and clean up resources
  static Future<void> dispose() async {
    await Supabase.instance.dispose();
    _client = null;
    _instance = null;
  }
}
