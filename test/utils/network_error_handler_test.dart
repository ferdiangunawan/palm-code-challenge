import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:palm_code_challenge/common/utils/network_error_handler.dart';

void main() {
  group('NetworkErrorHandler Tests', () {
    group('isImageLoadingError', () {
      test('should return true for image host errors', () {
        final dioError = DioException(
          requestOptions: RequestOptions(
            path: '/image.jpg',
            baseUrl: 'https://placeholder.com',
          ),
          type: DioExceptionType.connectionError,
        );

        expect(NetworkErrorHandler.isImageLoadingError(dioError), isTrue);
      });

      test('should return true for via.placeholder.com errors', () {
        final dioError = DioException(
          requestOptions: RequestOptions(
            path: '/150/200',
            baseUrl: 'https://via.placeholder.com',
          ),
          type: DioExceptionType.connectionTimeout,
        );

        expect(NetworkErrorHandler.isImageLoadingError(dioError), isTrue);
      });

      test('should return true for picsum.photos errors', () {
        final dioError = DioException(
          requestOptions: RequestOptions(
            path: '/200/300',
            baseUrl: 'https://picsum.photos',
          ),
          type: DioExceptionType.connectionError,
        );

        expect(NetworkErrorHandler.isImageLoadingError(dioError), isTrue);
      });

      test('should return true for image file extension errors', () {
        final dioError = DioException(
          requestOptions: RequestOptions(
            path: '/assets/book-cover.jpg',
            baseUrl: 'https://example.com',
          ),
          type: DioExceptionType.badResponse,
        );

        expect(NetworkErrorHandler.isImageLoadingError(dioError), isTrue);
      });

      test('should return true for various image extensions', () {
        final extensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp', '.svg'];

        for (final ext in extensions) {
          final dioError = DioException(
            requestOptions: RequestOptions(
              path: '/image$ext',
              baseUrl: 'https://example.com',
            ),
            type: DioExceptionType.badResponse,
          );

          expect(
            NetworkErrorHandler.isImageLoadingError(dioError),
            isTrue,
            reason: 'Should detect $ext as image extension',
          );
        }
      });

      test('should return true for errors with image-related messages', () {
        final dioError = DioException(
          requestOptions: RequestOptions(
            path: '/api/data',
            baseUrl: 'https://example.com',
          ),
          type: DioExceptionType.badResponse,
          message: 'Failed to load image from server',
        );

        expect(NetworkErrorHandler.isImageLoadingError(dioError), isTrue);
      });

      test('should return false for non-image API errors', () {
        final dioError = DioException(
          requestOptions: RequestOptions(
            path: '/api/books',
            baseUrl: 'https://api.example.com',
          ),
          type: DioExceptionType.badResponse,
        );

        expect(NetworkErrorHandler.isImageLoadingError(dioError), isFalse);
      });

      test('should return true for SocketException with placeholder terms', () {
        final exception = Exception(
          'SocketException: Failed host lookup: placeholder.com',
        );
        expect(NetworkErrorHandler.isImageLoadingError(exception), isTrue);
      });

      test('should return false for regular SocketException', () {
        final exception = Exception(
          'SocketException: Failed host lookup: api.example.com',
        );
        expect(NetworkErrorHandler.isImageLoadingError(exception), isFalse);
      });

      test('should return false for non-Exception errors', () {
        expect(
          NetworkErrorHandler.isImageLoadingError('String error'),
          isFalse,
        );
        expect(NetworkErrorHandler.isImageLoadingError(123), isFalse);
        expect(NetworkErrorHandler.isImageLoadingError(null), isFalse);
      });
    });

    group('getUserFriendlyMessage', () {
      test('should return loading message for image errors', () {
        final dioError = DioException(
          requestOptions: RequestOptions(
            path: '/image.jpg',
            baseUrl: 'https://placeholder.com',
          ),
          type: DioExceptionType.connectionError,
        );

        expect(
          NetworkErrorHandler.getUserFriendlyMessage(dioError),
          equals('Loading content...'),
        );
      });

      test('should return timeout message for connection timeout', () {
        final dioError = DioException(
          requestOptions: RequestOptions(path: '/api/books'),
          type: DioExceptionType.connectionTimeout,
        );

        expect(
          NetworkErrorHandler.getUserFriendlyMessage(dioError),
          equals('Connection timeout. Please check your internet connection.'),
        );
      });

      test('should return timeout message for receive timeout', () {
        final dioError = DioException(
          requestOptions: RequestOptions(path: '/api/books'),
          type: DioExceptionType.receiveTimeout,
        );

        expect(
          NetworkErrorHandler.getUserFriendlyMessage(dioError),
          equals('Connection timeout. Please check your internet connection.'),
        );
      });

      test('should return connection error message', () {
        final dioError = DioException(
          requestOptions: RequestOptions(path: '/api/books'),
          type: DioExceptionType.connectionError,
        );

        expect(
          NetworkErrorHandler.getUserFriendlyMessage(dioError),
          equals('No internet connection. Showing cached content.'),
        );
      });

      test('should return specific message for 404 error', () {
        final dioError = DioException(
          requestOptions: RequestOptions(path: '/api/books'),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: '/api/books'),
            statusCode: 404,
          ),
        );

        expect(
          NetworkErrorHandler.getUserFriendlyMessage(dioError),
          equals('Content not found.'),
        );
      });

      test('should return specific message for 500 error', () {
        final dioError = DioException(
          requestOptions: RequestOptions(path: '/api/books'),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: '/api/books'),
            statusCode: 500,
          ),
        );

        expect(
          NetworkErrorHandler.getUserFriendlyMessage(dioError),
          equals('Server error. Please try again later.'),
        );
      });

      test('should return generic server error for other status codes', () {
        final dioError = DioException(
          requestOptions: RequestOptions(path: '/api/books'),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: '/api/books'),
            statusCode: 418,
          ),
        );

        expect(
          NetworkErrorHandler.getUserFriendlyMessage(dioError),
          equals('Server error (418). Please try again.'),
        );
      });

      test('should return cancel message for cancelled requests', () {
        final dioError = DioException(
          requestOptions: RequestOptions(path: '/api/books'),
          type: DioExceptionType.cancel,
        );

        expect(
          NetworkErrorHandler.getUserFriendlyMessage(dioError),
          equals('Request was cancelled.'),
        );
      });

      test('should return offline message for unknown errors', () {
        final dioError = DioException(
          requestOptions: RequestOptions(path: '/api/books'),
          type: DioExceptionType.unknown,
        );

        expect(
          NetworkErrorHandler.getUserFriendlyMessage(dioError),
          equals('Connection failed. Showing offline content.'),
        );
      });

      test('should return generic message for non-DioException errors', () {
        final error = Exception('Generic error');

        expect(
          NetworkErrorHandler.getUserFriendlyMessage(error),
          equals('Unable to load content. Please try again.'),
        );
      });
    });

    group('isNetworkConnectivityError', () {
      test('should return true for connection-related messages', () {
        final messages = [
          'No connection available',
          'Connection failed',
          'Network connection lost',
          'Internet connection required',
          'Connection timeout occurred',
          'Network unreachable',
          'Device is offline',
        ];

        for (final message in messages) {
          expect(
            NetworkErrorHandler.isNetworkConnectivityError(message),
            isTrue,
            reason: 'Should detect "$message" as connectivity error',
          );
        }
      });

      test('should return false for non-connectivity messages', () {
        final messages = [
          'Server error occurred',
          'Invalid data format',
          'Authentication failed',
          'Permission denied',
          'Resource not found',
        ];

        for (final message in messages) {
          expect(
            NetworkErrorHandler.isNetworkConnectivityError(message),
            isFalse,
            reason: 'Should not detect "$message" as connectivity error',
          );
        }
      });

      test('should be case insensitive', () {
        expect(
          NetworkErrorHandler.isNetworkConnectivityError('CONNECTION FAILED'),
          isTrue,
        );
        expect(
          NetworkErrorHandler.isNetworkConnectivityError('Network Error'),
          isTrue,
        );
      });
    });
  });
}
