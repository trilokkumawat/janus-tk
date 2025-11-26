import 'package:dio/dio.dart';
import 'package:janus/domain/entities/appheaderenum.dart';
import 'package:janus/data/services/api_call_handler.dart';

class RestApi {
  static const String baseUrl = 'https://your-api-base-url.com';

  static const String baseUrlfun = 'https://xgwcaydtrbdxjngkrwvy.supabase.co';
  static const String apiEntryPoint = 'api/v1/';
  static const String apiEntryPointfun = 'function/v1/';

  static String get apiBaseUrl => '$baseUrl/$apiEntryPoint';
  static String get apiBaseUrlfun => '$baseUrlfun/$apiEntryPointfun';
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Dio _dioWithBaseUrl(String base) => Dio(
    BaseOptions(
      baseUrl: base,
      headers: defaultHeaders,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  // Create ApiCallHandler instance for the given base URL
  static ApiCallHandler _getApiCallHandler(bool useFunctionApi) {
    final dio = _dioWithBaseUrl(useFunctionApi ? apiBaseUrlfun : apiBaseUrl);
    return ApiCallHandler(dio: dio);
  }

  static void setAuthToken(String token, {bool useFunctionApi = false}) {
    final dio = _dioWithBaseUrl(useFunctionApi ? apiBaseUrlfun : apiBaseUrl);
    dio.options.headers['Authorization'] = 'Bearer $token';
  }

  static void clearAuthToken({bool useFunctionApi = false}) {
    final dio = _dioWithBaseUrl(useFunctionApi ? apiBaseUrlfun : apiBaseUrl);
    dio.options.headers.remove('Authorization');
  }

  static void addHeader(
    String key,
    String value, {
    bool useFunctionApi = false,
  }) {
    final dio = _dioWithBaseUrl(useFunctionApi ? apiBaseUrlfun : apiBaseUrl);
    dio.options.headers[key] = value;
  }

  static void removeHeader(String key, {bool useFunctionApi = false}) {
    final dio = _dioWithBaseUrl(useFunctionApi ? apiBaseUrlfun : apiBaseUrl);
    dio.options.headers.remove(key);
  }

  static Future<Response> makeApiCall(
    ApiCallType type,
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    Options? options,
    bool useFunctionApi = false, // ADDED as per instruction
  }) async {
    final apiCallHandler = _getApiCallHandler(useFunctionApi);
    return await apiCallHandler.makeApiCall(
      type,
      endpoint,
      data: data,
      queryParameters: queryParameters,
      headers: headers,
      options: options,
    );
  }

  static Future<Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    Options? options,
    bool useFunctionApi = false,
  }) async {
    return await makeApiCall(
      ApiCallType.GET,
      endpoint,
      queryParameters: queryParameters,
      headers: headers,
      options: options,
      useFunctionApi: useFunctionApi,
    );
  }

  static SendMessageCall sendMessageCall = SendMessageCall();
  static DealActivityCallv2 dealActivityCallv2 = DealActivityCallv2();
}

class ApiResponse {
  final bool success;
  final dynamic data;
  final String? message;
  final int? statusCode;

  ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.statusCode,
  });

  factory ApiResponse.fromResponse(Response response) {
    return ApiResponse(
      success:
          response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300,
      data: response.data,
      statusCode: response.statusCode,
    );
  }
}

class SendMessageCall {
  Future<ApiResponse> call({
    String? user = '',
    String? contact = '',
    String? messageContent = '',
    String? conversation = '',
    bool useFunctionApi = false, // ADDED parameter
  }) async {
    try {
      final response = await RestApi.makeApiCall(
        ApiCallType.POST,
        'send_twilio_sms',
        data: {
          'User': user,
          'Contact': contact,
          'Message Content': messageContent,
          'Conversation': conversation,
        },
        useFunctionApi: useFunctionApi, // PASSED DOWN
      );

      return ApiResponse.fromResponse(response);
    } catch (e) {
      return ApiResponse(success: false, message: e.toString());
    }
  }
}

class DealActivityCallv2 {
  Future<ApiResponse> call({
    String? owner = '',
    String? deal = '',
    bool useFunctionApi = false, // ADDED parameter
  }) async {
    try {
      final response = await RestApi.makeApiCall(
        ApiCallType.GET,
        'deal_activity_v2',
        queryParameters: {'owner': owner, 'deal': deal},
        useFunctionApi: useFunctionApi, // PASSED DOWN
      );

      return ApiResponse.fromResponse(response);
    } catch (e) {
      return ApiResponse(success: false, message: e.toString());
    }
  }
}
