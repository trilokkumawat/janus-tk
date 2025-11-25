import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Supabase configuration constants
///
/// These values are loaded from the .env file
/// Make sure to create a .env file in the root directory with your credentials
/// See .env.example for the required format
class SupabaseConstants {
  /// Your Supabase project URL
  /// Loaded from SUPABASE_URL in .env file
  /// Example: 'https://your-project-id.supabase.co'
  static String get supabaseUrl {
    final url = dotenv.env['SUPABASE_URL'];
    if (url == null || url.isEmpty) {
      throw Exception(
        'SUPABASE_URL not found in .env file. Please add it to your .env file.',
      );
    }
    return url;
  }

  /// Your Supabase anon/public key
  /// Loaded from SUPABASE_ANON_KEY in .env file
  /// This is safe to use in client-side applications
  static String get supabaseAnonKey {
    final key = dotenv.env['SUPABASE_ANON_KEY'];
    if (key == null || key.isEmpty) {
      throw Exception(
        'SUPABASE_ANON_KEY not found in .env file. Please add it to your .env file.',
      );
    }
    return key;
  }

  /// Enable real-time subscriptions by default
  static const bool enableRealtime = true;

  /// Default timeout for database operations (in seconds)
  static const int defaultTimeout = 30;
}
