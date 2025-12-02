import 'package:dio/dio.dart';

/// Handles Dio exceptions and converts them to user-friendly exceptions
class ApiErrorHandler {
  /// Handles DioException and returns a user-friendly Exception
  static Exception handleError(DioException error) {
    // Check if error message indicates internet connectivity issues
    final errorMessage = error.message?.toLowerCase() ?? '';
    final isInternetError = _isInternetError(errorMessage);

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return Exception(
          'Connection timeout. Please check your internet connection and try again.',
        );
      case DioExceptionType.sendTimeout:
        return Exception(
          'Request timeout while sending data. Please check your internet connection.',
        );
      case DioExceptionType.receiveTimeout:
        return Exception(
          'Request timeout while receiving data. Please check your internet connection.',
        );
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode != null) {
          if (statusCode >= 500) {
            return Exception(
              'Server error. Please try again later or contact support if the problem persists.',
            );
          } else if (statusCode == 404) {
            return Exception('The requested resource was not found.');
          } else if (statusCode == 401) {
            return Exception('Authentication failed. Please login again.');
          } else if (statusCode == 403) {
            return Exception(
              'You do not have permission to access this resource.',
            );
          }
        }
        return Exception(
          'Server error: ${error.response?.statusCode} - ${error.response?.statusMessage ?? 'Unknown error'}',
        );
      case DioExceptionType.cancel:
        return Exception('Request was cancelled.');
      case DioExceptionType.connectionError:
        return Exception(
          'No internet connection. Please check your network settings and try again.',
        );
      case DioExceptionType.badCertificate:
        return Exception(
          'SSL certificate error. Please check your connection security.',
        );
      case DioExceptionType.unknown:
        if (isInternetError) {
          return Exception(
            'No internet connection. Please check your network and try again.',
          );
        }
        return Exception(
          'Network error: ${error.message ?? 'Unable to connect to the server. Please check your internet connection.'}',
        );
    }
  }

  /// Checks if the error message indicates an internet connectivity issue
  static bool _isInternetError(String errorMessage) {
    final internetErrorKeywords = [
      'network',
      'internet',
      'connection',
      'socket',
      'host lookup',
      'failed host lookup',
      'no internet',
      'offline',
      'unreachable',
      'dns',
      'network is unreachable',
      'connection refused',
      'connection reset',
    ];

    return internetErrorKeywords.any(
      (keyword) => errorMessage.contains(keyword),
    );
  }
}
