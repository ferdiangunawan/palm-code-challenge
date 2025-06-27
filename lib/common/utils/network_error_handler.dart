import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class NetworkErrorHandler {
  /// Check if error is related to image loading and should be handled silently
  static bool isImageLoadingError(dynamic error) {
    if (error is DioException) {
      final uri = error.requestOptions.uri;

      // Check if the error is from image-related hosts
      final imageHosts = [
        'placeholder.com',
        'via.placeholder.com',
        'picsum.photos',
        'dummyimage.com',
        'lorempicsum.com',
      ];

      for (final host in imageHosts) {
        if (uri.host.contains(host)) return true;
      }

      // Check if the URL looks like an image
      final path = uri.path.toLowerCase();
      final imageExtensions = [
        '.jpg',
        '.jpeg',
        '.png',
        '.gif',
        '.webp',
        '.svg',
      ];
      for (final ext in imageExtensions) {
        if (path.endsWith(ext)) return true;
      }

      // Check if the error message contains image-related terms
      final message = error.message?.toLowerCase() ?? '';
      if (message.contains('image') ||
          message.contains('picture') ||
          message.contains('photo')) {
        return true;
      }
    }

    if (error is Exception) {
      final errorString = error.toString().toLowerCase();
      if (errorString.contains('socketexception')) {
        // Check for image-related hosts in socket exceptions
        return errorString.contains('placeholder') ||
            errorString.contains('image') ||
            errorString.contains('picsum') ||
            errorString.contains('dummyimage');
      }
    }

    return false;
  }

  /// Get user-friendly error message, filtering out image loading errors
  static String getUserFriendlyMessage(dynamic error) {
    // If it's an image loading error, return a generic loading message
    if (isImageLoadingError(error)) {
      return 'Loading content...';
    }

    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
          return 'Connection timeout. Please check your internet connection.';
        case DioExceptionType.connectionError:
          return 'No internet connection. Showing cached content.';
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          if (statusCode != null) {
            switch (statusCode) {
              case 404:
                return 'Content not found.';
              case 500:
                return 'Server error. Please try again later.';
              case 503:
                return 'Service temporarily unavailable.';
              default:
                return 'Server error ($statusCode). Please try again.';
            }
          }
          return 'Server error. Please try again later.';
        case DioExceptionType.cancel:
          return 'Request was cancelled.';
        case DioExceptionType.unknown:
          return 'Connection failed. Showing offline content.';
        default:
          return 'Something went wrong. Please try again.';
      }
    }

    return 'Unable to load content. Please try again.';
  }

  /// Log error for debugging without cluttering user interface
  static void logError(dynamic error, [String? context]) {
    if (kDebugMode) {
      final contextStr = context != null ? '[$context] ' : '';

      // Only log non-image errors to reduce noise
      if (!isImageLoadingError(error)) {
        debugPrint('${contextStr}Network Error: $error');
      } else {
        // For image errors, just log a simple message
        debugPrint('${contextStr}Image loading failed (handled gracefully)');
      }
    }
  }

  /// Check if error message indicates a network connectivity issue
  static bool isNetworkConnectivityError(String message) {
    final lowerMessage = message.toLowerCase();
    return lowerMessage.contains('connection') ||
        lowerMessage.contains('offline') ||
        lowerMessage.contains('internet') ||
        lowerMessage.contains('network') ||
        lowerMessage.contains('timeout') ||
        lowerMessage.contains('unreachable');
  }
}
