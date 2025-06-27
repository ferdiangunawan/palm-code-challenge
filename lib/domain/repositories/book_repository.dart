import '../entities/book.dart';

abstract class BookRepository {
  Future<List<Book>> getBooks({int page = 1, String? search});

  Future<Book?> getBookById(int id);

  Future<List<Book>> getLikedBooks();

  Future<void> toggleLikeBook(Book book);

  Future<bool> isBookLiked(int bookId);
}
