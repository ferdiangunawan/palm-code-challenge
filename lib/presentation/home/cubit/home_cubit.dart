import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palm_code_challenge/common/utils/index.dart';
import 'package:palm_code_challenge/data/models/index.dart';
import 'package:palm_code_challenge/data/models/params/index.dart';
import 'package:palm_code_challenge/domain/repositories/index.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final BooksRepository _booksRepository;
  final LikedBooksRepository _likedBooksRepository;

  Timer? _debounceTimer;

  HomeCubit(this._booksRepository, this._likedBooksRepository)
    : super(
        HomeState(
          booksLoadData: ViewData.initial(),
          books: [],
          params: const ParamGetBooks(),
          hasReachedMax: false,
          isLoadingMore: false,
          likedBookIds: {},
        ),
      ) {
    _initializeLikedBooks();
  }

  void _initializeLikedBooks() {
    final likedBooks = _likedBooksRepository.getLikedBooks();
    final likedBookIds = likedBooks.map((book) => book.id).toSet();
    emit(state.copyWith(likedBookIds: likedBookIds));
  }

  Future<void> loadBooks() async {
    if (state.booksLoadData.isLoading) return;

    emit(state.copyWith(booksLoadData: ViewData.loading()));
    try {
      final newParams = state.params.copyWith(page: 1);

      final response = await _booksRepository.getBooks(
        page: newParams.page,
        search: newParams.search,
      );

      final newBooks = response.results;
      final hasReachedMax = !response.hasMore;

      // Refresh liked books state
      final likedBooks = _likedBooksRepository.getLikedBooks();
      final likedBookIds = likedBooks.map((book) => book.id).toSet();

      if (newBooks.isEmpty) {
        emit(
          state.copyWith(
            booksLoadData: ViewData.noData(message: 'No books found'),
            books: newBooks,
            params: newParams,
            hasReachedMax: hasReachedMax,
            likedBookIds: likedBookIds,
          ),
        );
      } else {
        emit(
          state.copyWith(
            booksLoadData: ViewData.loaded(data: newBooks),
            books: newBooks,
            params: newParams,
            hasReachedMax: hasReachedMax,
            likedBookIds: likedBookIds,
          ),
        );
      }
    } catch (e) {
      // Log error for debugging and get user-friendly message
      NetworkErrorHandler.logError(e, 'HomeCubit.loadBooks');
      final errorMessage = NetworkErrorHandler.getUserFriendlyMessage(e);

      emit(
        state.copyWith(
          booksLoadData: ViewData.error(
            message: errorMessage,
            data: state.books.isNotEmpty ? state.books : null,
          ),
        ),
      );
    }
  }

  Future<void> loadMoreBooks() async {
    if (state.hasReachedMax || state.booksLoadData.isLoading) return;

    try {
      emit(state.copyWith(isLoadingMore: true));

      final newParams = state.params.copyWith(page: state.params.page + 1);
      final response = await _booksRepository.getBooks(
        page: newParams.page,
        search: newParams.search,
      );

      final updatedBooks = List<Book>.from(state.books)
        ..addAll(response.results);
      final hasReachedMax = !response.hasMore;

      emit(
        state.copyWith(
          booksLoadData: ViewData.loaded(data: updatedBooks),
          books: updatedBooks,
          params: newParams,
          hasReachedMax: hasReachedMax,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      NetworkErrorHandler.logError(e, 'HomeCubit.loadMoreBooks');
      emit(
        state.copyWith(
          booksLoadData: ViewData.error(
            message: NetworkErrorHandler.getUserFriendlyMessage(e),
            data: state.books,
          ),
          isLoadingMore: false,
        ),
      );
    }
  }

  void search(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      final searchQuery = query.trim().isEmpty ? null : query.trim();
      final newParams = state.params.copyWith(search: searchQuery);
      emit(state.copyWith(params: newParams));
      loadBooks();
    });
  }

  void clearSearch() {
    final newParams = state.params.copyWith(search: null);
    emit(state.copyWith(params: newParams));
    loadBooks();
  }

  Future<void> toggleBookLike(Book book) async {
    try {
      final currentLikeStatus = state.likedBookIds.contains(book.id);
      final newLikedBookIds = Set<int>.from(state.likedBookIds);

      if (currentLikeStatus) {
        await _likedBooksRepository.unlikeBook(book.id);
        newLikedBookIds.remove(book.id);
      } else {
        await _likedBooksRepository.likeBook(book);
        newLikedBookIds.add(book.id);
      }

      // Update the like status immediately
      emit(state.copyWith(likedBookIds: newLikedBookIds));
    } catch (e) {
      // On error, refresh the liked books state to ensure consistency
      _initializeLikedBooks();
      emit(
        state.copyWith(
          booksLoadData: ViewData.error(
            message: NetworkErrorHandler.getUserFriendlyMessage(e),
            data: state.books,
          ),
        ),
      );
    }
  }

  bool isBookLiked(int bookId) {
    return state.likedBookIds.contains(bookId);
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
