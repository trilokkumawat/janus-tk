import 'package:dio/dio.dart';

/// Handles Dio exceptions and converts them to user-friendly exceptions
class ApiErrorHandler {
  /// Handles DioException and returns a user-friendly Exception
  static Exception handleError(DioException error) {
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
}
