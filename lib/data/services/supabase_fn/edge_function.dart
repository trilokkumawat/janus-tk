import 'package:janus/core/constants/supabase_constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabase_service.dart';

class SupabaseEdgeFunctionService {
  static Map<String, String> get defaultHeaders => {
    "Content-Type": "application/json",
    "Authorization": "Bearer ${SupabaseConstants.supabaseAnonKey}",
  };

  /// Generic method to call edge function with specified HTTP method
  static Future<dynamic> call(
    String functionName, {
    dynamic body,
    HttpMethod method = HttpMethod.get,
    Map<String, String>? headers,
  }) async {
    try {
      final client = SupabaseService.client;
      final response = await client.functions.invoke(
        functionName,
        body: body,
        headers: headers ?? defaultHeaders,
        method: method,
      );

      // Accept 200, 201, 204 as success status codes
      if (response.status < 200 || response.status >= 300) {
        throw Exception(
          'Supabase Edge Function "$functionName" failed: ${response.status}',
        );
      }
      return response.data;
    } catch (e) {
      throw Exception(
        'Failed to call Supabase Edge Function "$functionName": $e',
      );
    }
  }

  /// CREATE operation - POST request
  /// Typically used to create new resources
  /// CREATE operation - POST request, returns response data
  static Future<dynamic> create(String functionName, {dynamic body}) async {
    return await call(
      functionName,
      body: body,
      method: HttpMethod.post,
      headers: defaultHeaders,
    );
  }

  /// CREATE operation - POST request, does not return data (ignores response)
  static Future<void> createNoReturn(
    String functionName, {
    dynamic body,
  }) async {
    await call(
      functionName,
      body: body,
      method: HttpMethod.post,
      headers: defaultHeaders,
    );
  }

  /// READ operation - GET request
  /// Typically used to retrieve/fetch resources
  static Future<dynamic> read(
    String functionName, {
    Map<String, String>? headers,
  }) async {
    return await call(
      functionName,
      method: HttpMethod.get,
      headers: headers ?? defaultHeaders,
    );
  }

  /// UPDATE operation - PUT request
  /// Typically used to update/replace entire resources
  static Future<dynamic> update(
    String functionName, {
    dynamic body,
    Map<String, String>? headers,
  }) async {
    return await call(
      functionName,
      body: body,
      method: HttpMethod.put,
      headers: headers,
    );
  }

  /// UPDATE operation - PATCH request
  /// Typically used to partially update resources
  static Future<dynamic> patch(
    String functionName, {
    dynamic body,
    Map<String, String>? headers,
  }) async {
    return await call(
      functionName,
      body: body,
      method: HttpMethod.patch,
      headers: headers,
    );
  }

  /// DELETE operation - DELETE request
  /// Typically used to delete resources
  static Future<dynamic> delete(
    String functionName, {
    dynamic body,
    Map<String, String>? headers,
  }) async {
    return await call(
      functionName,
      body: body,
      method: HttpMethod.delete,
      headers: headers,
    );
  }
}
