import 'package:dio/dio.dart';
import 'package:janus/domain/entities/appheaderenum.dart';
import 'package:janus/data/services/api_error_handler.dart';

/// Handles API calls using Dio
class ApiCallHandler {
  final Dio dio;
  final ApiErrorHandler errorHandler;

  ApiCallHandler({required this.dio, ApiErrorHandler? errorHandler})
    : errorHandler = errorHandler ?? ApiErrorHandler();

  /// Makes an API call based on the provided type and parameters
  Future<Response> makeApiCall(
    ApiCallType type,
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    Options? options,
  }) async {
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
      }
    } on DioException catch (e) {
      print(e.response?.data);
      throw ApiErrorHandler.handleError(e);
    }
  }
}
