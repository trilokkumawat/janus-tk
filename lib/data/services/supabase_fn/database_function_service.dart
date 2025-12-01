import 'supabase_service.dart';

class SupabaseFunctionService {
  static Future<dynamic> call(
    String functionName, {
    Map<String, dynamic>? params,
  }) async {
    try {
      final client = SupabaseService.client;
      final response = await client.rpc(functionName, params: params ?? {});
      return response;
    } catch (e) {
      throw Exception('Failed to call database function "$functionName": $e');
    }
  }

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
