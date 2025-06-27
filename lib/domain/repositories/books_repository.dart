import 'package:palm_code_challenge/data/models/index.dart';

abstract class BooksRepository {
  Future<BooksResponse> getBooks({int page = 1, String? search});

  Future<Book> getBookById(int id);
}

abstract class LikedBooksRepository {
  List<Book> getLikedBooks();

  Future<void> likeBook(Book book);

  Future<void> unlikeBook(int bookId);

  bool isBookLiked(int bookId);

  Stream<List<Book>> watchLikedBooks();
}
