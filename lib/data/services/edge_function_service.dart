import 'supabase_service.dart';

/// Service for calling Supabase Edge Functions
///
/// Edge Functions are serverless functions deployed on Supabase
/// that can be called from the client side.
///
/// Example:
/// ```dart
/// final result = await EdgeFunctionService.invoke(
///   'my-function',
///   body: {'key': 'value'},
/// );
/// ```
class EdgeFunctionService {
  /// Invoke a Supabase Edge Function
  ///
  /// [functionName] - The name of the Edge Function to invoke
  /// [body] - Optional request body (will be sent as JSON)
  /// [headers] - Optional custom headers
  ///
  /// Returns the response data from the Edge Function
  /// Throws an error if the function call fails
  static Future<Map<String, dynamic>> invoke(
    String functionName, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      final client = SupabaseService.client;

      // Prepare headers
      final requestHeaders = <String, String>{
        'Content-Type': 'application/json',
        ...?headers,
      };

      // Invoke the Edge Function
      final response = await client.functions.invoke(
        functionName,
        body: body,
        headers: requestHeaders,
      );

      // Parse response
      if (response.data is Map) {
        return Map<String, dynamic>.from(response.data as Map);
      } else if (response.data is List) {
        return {'data': response.data};
      } else {
        return {'data': response.data};
      }
    } catch (e) {
      throw Exception('Failed to invoke Edge Function "$functionName": $e');
    }
  }

  /// Invoke a Supabase Edge Function with GET method
  ///
  /// [functionName] - The name of the Edge Function to invoke
  /// [queryParams] - Optional query parameters (passed as body for GET)
  /// [headers] - Optional custom headers
  ///
  /// Returns the response data from the Edge Function
  static Future<Map<String, dynamic>> get(
    String functionName, {
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
  }) async {
    // For GET requests, pass query params as body
    return invoke(functionName, body: queryParams, headers: headers);
  }

  /// Invoke a Supabase Edge Function with POST method
  ///
  /// [functionName] - The name of the Edge Function to invoke
  /// [body] - Request body (will be sent as JSON)
  /// [headers] - Optional custom headers
  ///
  /// Returns the response data from the Edge Function
  static Future<Map<String, dynamic>> post(
    String functionName, {
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  }) async {
    return invoke(functionName, body: body, headers: headers);
  }

  /// Invoke a Supabase Edge Function with PUT method
  ///
  /// [functionName] - The name of the Edge Function to invoke
  /// [body] - Request body (will be sent as JSON)
  /// [headers] - Optional custom headers
  ///
  /// Returns the response data from the Edge Function
  static Future<Map<String, dynamic>> put(
    String functionName, {
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  }) async {
    return invoke(functionName, body: body, headers: headers);
  }

  /// Invoke a Supabase Edge Function with DELETE method
  ///
  /// [functionName] - The name of the Edge Function to invoke
  /// [body] - Optional request body
  /// [headers] - Optional custom headers
  ///
  /// Returns the response data from the Edge Function
  static Future<Map<String, dynamic>> delete(
    String functionName, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    return invoke(functionName, body: body, headers: headers);
  }
}
