import 'supabase_service.dart';

/// Service for calling PostgreSQL database functions (RPC)
///
/// Database functions are PostgreSQL functions that can be called
/// via Supabase RPC (Remote Procedure Call).
///
/// Example:
/// ```dart
/// final result = await DatabaseFunctionService.call(
///   'get_user_tasks',
///   params: {'user_id': 123},
/// );
/// ```
class DatabaseFunctionService {
  /// Call a PostgreSQL database function via RPC
  ///
  /// [functionName] - The name of the database function to call
  /// [params] - Optional parameters to pass to the function
  ///
  /// Returns the response data from the database function
  /// Throws an error if the function call fails
  static Future<dynamic> call(
    String functionName, {
    Map<String, dynamic>? params,
  }) async {
    try {
      final client = SupabaseService.client;

      // Call the RPC function
      final response = await client.rpc(functionName, params: params ?? {});

      return response;
    } catch (e) {
      throw Exception('Failed to call database function "$functionName": $e');
    }
  }

  /// Call a PostgreSQL database function and return as List
  ///
  /// [functionName] - The name of the database function to call
  /// [params] - Optional parameters to pass to the function
  ///
  /// Returns a List of results from the database function
  static Future<List<Map<String, dynamic>>> callAsList(
    String functionName, {
    Map<String, dynamic>? params,
  }) async {
    try {
      final result = await call(functionName, params: params);

      if (result is List) {
        return result
            .map((item) => Map<String, dynamic>.from(item as Map))
            .toList();
      } else if (result is Map) {
        return [Map<String, dynamic>.from(result)];
      } else {
        return [];
      }
    } catch (e) {
      throw Exception(
        'Failed to call database function "$functionName" as list: $e',
      );
    }
  }

  /// Call a PostgreSQL database function and return as Map
  ///
  /// [functionName] - The name of the database function to call
  /// [params] - Optional parameters to pass to the function
  ///
  /// Returns a Map result from the database function
  static Future<Map<String, dynamic>> callAsMap(
    String functionName, {
    Map<String, dynamic>? params,
  }) async {
    try {
      final result = await call(functionName, params: params);

      if (result is Map) {
        return Map<String, dynamic>.from(result);
      } else if (result is List && result.isNotEmpty) {
        return Map<String, dynamic>.from(result.first as Map);
      } else {
        throw Exception('Function "$functionName" did not return a Map');
      }
    } catch (e) {
      throw Exception(
        'Failed to call database function "$functionName" as map: $e',
      );
    }
  }

  /// Call a PostgreSQL database function and return a single value
  ///
  /// [functionName] - The name of the database function to call
  /// [params] - Optional parameters to pass to the function
  ///
  /// Returns a single value from the database function
  static Future<T> callAsValue<T>(
    String functionName, {
    Map<String, dynamic>? params,
  }) async {
    try {
      final result = await call(functionName, params: params);

      if (result is T) {
        return result;
      } else {
        throw Exception(
          'Function "$functionName" did not return expected type ${T.toString()}',
        );
      }
    } catch (e) {
      throw Exception(
        'Failed to call database function "$functionName" as value: $e',
      );
    }
  }
}
