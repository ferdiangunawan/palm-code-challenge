import 'package:hive/hive.dart';
import 'package:palm_code_challenge/core/storage/index.dart';
import 'package:palm_code_challenge/data/models/index.dart';

class LikedBooksLocalDataSource {
  Box<Book> get _box => StorageService.likedBooksBox;

  List<Book> getLikedBooks() {
    return _box.values.toList();
  }

  Future<void> likeBook(Book book) async {
    await _box.put(book.id, book);
  }

  Future<void> unlikeBook(int bookId) async {
    await _box.delete(bookId);
  }

  bool isBookLiked(int bookId) {
    return _box.containsKey(bookId);
  }

  Stream<List<Book>> watchLikedBooks() {
    return _box.watch().map((_) => getLikedBooks());
  }
}
