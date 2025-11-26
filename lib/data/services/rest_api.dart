import 'package:dio/dio.dart';
import 'package:janus/core/constants/supabase_constants.dart';
import 'package:janus/domain/entities/appheaderenum.dart';
import 'package:janus/data/services/api_call_handler.dart';

class JanusApiGroup {
  static const String baseUrl = 'https://your-api-base-url.com';

  static const String baseUrlfun = 'https://xgwcaydtrbdxjngkrwvy.supabase.co';
  static const String apiEntryPoint = 'api/v1/';
  static const String apiEntryPointfun = 'functions/v1/';

  static String get apiBaseUrl => '$baseUrl/$apiEntryPoint';
  static String get apiBaseUrlfun => '$baseUrlfun/$apiEntryPointfun';
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // New headers for function API, if needed
  static Map<String, String> get defaultHeadersFun => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    // Add here any additional headers specific to function API
    'Authorization':
        'Bearer ${SupabaseConstants.supabaseAnonKey}', // Added as per the condition
  };

  static Dio _dioWithBaseUrl(String base, {bool useFunctionApi = false}) => Dio(
    BaseOptions(
      baseUrl: base,
      headers: useFunctionApi ? defaultHeadersFun : defaultHeaders,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  // Create ApiCallHandler instance for the given base URL
  static ApiCallHandler _getApiCallHandler(bool useFunctionApi) {
    final dio = _dioWithBaseUrl(
      useFunctionApi ? apiBaseUrlfun : apiBaseUrl,
      useFunctionApi: useFunctionApi,
    );
    return ApiCallHandler(dio: dio);
  }

  static void setAuthToken(String token, {bool useFunctionApi = false}) {
    final dio = _dioWithBaseUrl(
      useFunctionApi ? apiBaseUrlfun : apiBaseUrl,
      useFunctionApi: useFunctionApi,
    );
    dio.options.headers['Authorization'] = 'Bearer $token';
    if (useFunctionApi) {
      dio.options.headers['headerfun'] = 'headerfun';
    }
  }

  static void clearAuthToken({bool useFunctionApi = false}) {
    final dio = _dioWithBaseUrl(
      useFunctionApi ? apiBaseUrlfun : apiBaseUrl,
      useFunctionApi: useFunctionApi,
    );
    dio.options.headers.remove('Authorization');
    if (useFunctionApi) {
      dio.options.headers['headerfun'] = 'headerfun';
    }
  }

  static void addHeader(
    String key,
    String value, {
    bool useFunctionApi = false,
  }) {
    final dio = _dioWithBaseUrl(
      useFunctionApi ? apiBaseUrlfun : apiBaseUrl,
      useFunctionApi: useFunctionApi,
    );
    dio.options.headers[key] = value;
    if (useFunctionApi) {
      dio.options.headers['headerfun'] = 'headerfun';
    }
  }

  static void removeHeader(String key, {bool useFunctionApi = false}) {
    final dio = _dioWithBaseUrl(
      useFunctionApi ? apiBaseUrlfun : apiBaseUrl,
      useFunctionApi: useFunctionApi,
    );
    dio.options.headers.remove(key);
    if (useFunctionApi) {
      dio.options.headers['headerfun'] = 'headerfun';
    }
  }

  static Future<Response> makeApiCall(
    ApiCallType type,
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? params,
    Map<String, String>? headers,
    Options? options,
    bool useFunctionApi = false, // ADDED as per instruction
  }) async {
    // If useFunctionApi is true, ensure headerfun is included
    Map<String, String>? modHeaders = headers;
    if (useFunctionApi) {
      modHeaders = {...?headers, 'headerfun': 'headerfun'};
    }
    final apiCallHandler = _getApiCallHandler(useFunctionApi);
    return await apiCallHandler.makeApiCall(
      type,
      endpoint,
      data: data,
      queryParameters: params,
      headers: modHeaders,
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
      params: queryParameters,
      headers: headers,
      options: options,
      useFunctionApi: useFunctionApi,
    );
  }

  static SendMessageCall sendMessageCall = SendMessageCall();
  static DealActivityCallv2 dealActivityCallv2 = DealActivityCallv2();
  static Hellowfunctioncall hellofun = Hellowfunctioncall();
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
      final response = await JanusApiGroup.makeApiCall(
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
      final response = await JanusApiGroup.makeApiCall(
        ApiCallType.GET,
        'deal_activity_v2',
        params: {'owner': owner, 'deal': deal},
        useFunctionApi: useFunctionApi, // PASSED DOWN
      );

      return ApiResponse.fromResponse(response);
    } catch (e) {
      return ApiResponse(success: false, message: e.toString());
    }
  }
}

class Hellowfunctioncall {
  Future<ApiResponse> call({bool useFunctionApi = false}) async {
    try {
      final response = await JanusApiGroup.makeApiCall(
        ApiCallType.GET,
        'super-function',
        useFunctionApi: useFunctionApi,
      );

      return ApiResponse.fromResponse(response);
    } catch (e) {
      return ApiResponse(success: false, message: e.toString());
    }
  }
}
