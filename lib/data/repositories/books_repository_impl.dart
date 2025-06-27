import 'package:palm_code_challenge/data/datasources/index.dart';
import 'package:palm_code_challenge/data/models/index.dart';
import 'package:palm_code_challenge/domain/repositories/index.dart';

class BooksRepositoryImpl implements BooksRepository {
  final BooksRemoteDataSource _remoteDataSource;

  BooksRepositoryImpl(this._remoteDataSource);

  @override
  Future<BooksResponse> getBooks({int page = 1, String? search}) async {
    return await _remoteDataSource.getBooks(page: page, search: search);
  }

  @override
  Future<Book> getBookById(int id) async {
    return await _remoteDataSource.getBookById(id);
  }
}

class LikedBooksRepositoryImpl implements LikedBooksRepository {
  final LikedBooksLocalDataSource _localDataSource;

  LikedBooksRepositoryImpl(this._localDataSource);

  @override
  List<Book> getLikedBooks() {
    return _localDataSource.getLikedBooks();
  }

  @override
  Future<void> likeBook(Book book) async {
    await _localDataSource.likeBook(book);
  }

  @override
  Future<void> unlikeBook(int bookId) async {
    await _localDataSource.unlikeBook(bookId);
  }

  @override
  bool isBookLiked(int bookId) {
    return _localDataSource.isBookLiked(bookId);
  }

  @override
  Stream<List<Book>> watchLikedBooks() {
    return _localDataSource.watchLikedBooks();
  }
}
