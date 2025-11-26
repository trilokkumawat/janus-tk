import 'package:dio/dio.dart';
import 'package:janus/domain/entities/appheaderenum.dart';

class RestApi {
  static const String baseUrl = 'https://your-api-base-url.com';
  static const String baseUrlfun = 'https://your-api-base-url.com';
  static const String apiEntryPoint = 'api/v1/';
  static const String apiEntryPointfun = 'function/v1/';

  static String get apiBaseUrl => '$baseUrl/$apiEntryPoint';
  static String get apiBaseUrlfun => '$baseUrlfun/$apiEntryPointfun';
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // The default _dio will keep apiBaseUrl, but we will use baseUrl param in makeApiCall depending on useFunctionApi
  static Dio _dioWithBaseUrl(String base) => Dio(
    BaseOptions(
      baseUrl: base,
      headers: defaultHeaders,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

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
    final dio = _dioWithBaseUrl(useFunctionApi ? apiBaseUrlfun : apiBaseUrl);
    try {
      switch (type) {
        case ApiCallType.GET:
          return await dio.get(
            endpoint,
            queryParameters: queryParameters,
            options: options ?? Options(headers: headers),
          );
        case ApiCallType.POST:
          return await dio.post(
            endpoint,
            data: data,
            queryParameters: queryParameters,
            options: options ?? Options(headers: headers),
          );
        case ApiCallType.PUT:
          return await dio.put(
            endpoint,
            data: data,
            queryParameters: queryParameters,
            options: options ?? Options(headers: headers),
          );
        case ApiCallType.DELETE:
          return await dio.delete(
            endpoint,
            data: data,
            queryParameters: queryParameters,
            options: options ?? Options(headers: headers),
          );
        case ApiCallType.PATCH:
          return await dio.patch(
            endpoint,
            data: data,
            queryParameters: queryParameters,
            options: options ?? Options(headers: headers),
          );
        default:
          throw Exception('Unsupported ApiCallType: $type');
      }
    } on DioException catch (e) {
      throw _handleError(e);
    }
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

  static Exception _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Request timeout. Please check your connection.');
      case DioExceptionType.badResponse:
        return Exception(
          'Server error: ${error.response?.statusCode} - ${error.response?.statusMessage}',
        );
      case DioExceptionType.cancel:
        return Exception('Request was cancelled.');
      case DioExceptionType.connectionError:
        return Exception('Connection error. Please check your internet.');
      default:
        return Exception('An unexpected error occurred: ${error.message}');
    }
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
