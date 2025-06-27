import 'package:dio/dio.dart';
import 'package:palm_code_challenge/common/constants/index.dart';
import 'package:palm_code_challenge/core/network/index.dart';
import 'package:palm_code_challenge/data/models/index.dart';

class BooksRemoteDataSource {
  final NetworkClient _networkClient;

  BooksRemoteDataSource(this._networkClient);

  Future<BooksResponse> getBooks({int page = 1, String? search}) async {
    final queryParameters = <String, dynamic>{'page': page};

    if (search?.isNotEmpty ?? false) {
      queryParameters['search'] = search;
    }

    try {
      // First attempt with cache-first strategy
      final response = await _networkClient.get(
        ApiConstants.booksEndpoint,
        queryParameters: queryParameters,
        cacheStrategy: CacheStrategy.cacheFirst,
        cacheDuration: const Duration(hours: 3),
      );

      return BooksResponse.fromJson(response.data);
    } on DioException catch (e) {
      // If network fails, try cache-only approach
      if (_isNetworkError(e)) {
        try {
          final cacheResponse = await _networkClient.get(
            ApiConstants.booksEndpoint,
            queryParameters: queryParameters,
            cacheStrategy: CacheStrategy.cacheOnly,
          );
          return BooksResponse.fromJson(cacheResponse.data);
        } catch (_) {
          // If cache also fails, rethrow the original network error
          // This will be handled by the cubit with user-friendly messages
          rethrow;
        }
      }
      rethrow;
    }
  }

  Future<Book> getBookById(int id) async {
    try {
      // First attempt with cache-first strategy
      final response = await _networkClient.get(
        '${ApiConstants.booksEndpoint}/$id',
        cacheStrategy: CacheStrategy.cacheFirst,
        cacheDuration: const Duration(hours: 3),
      );

      return Book.fromJson(response.data);
    } on DioException catch (e) {
      // If network fails, try cache-only approach
      if (_isNetworkError(e)) {
        final cacheResponse = await _networkClient.get(
          '${ApiConstants.booksEndpoint}/$id',
          cacheStrategy: CacheStrategy.cacheOnly,
        );
        return Book.fromJson(cacheResponse.data);
      }
      rethrow;
    }
  }

  /// Helper method to identify network-related errors
  bool _isNetworkError(DioException e) {
    return e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.unknown;
  }
}
