class ApiConstants {
  static const String baseUrl = 'https://gutendex.com';
  static const String booksEndpoint = '/books';

  static const int pageSize = 20;
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
