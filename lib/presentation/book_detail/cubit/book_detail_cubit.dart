import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palm_code_challenge/common/utils/index.dart';
import 'package:palm_code_challenge/data/models/index.dart';
import 'package:palm_code_challenge/domain/repositories/index.dart';

part 'book_detail_state.dart';

class BookDetailCubit extends Cubit<BookDetailState> {
  final BooksRepository _booksRepository;
  final LikedBooksRepository _likedBooksRepository;

  BookDetailCubit(this._booksRepository, this._likedBooksRepository)
    : super(BookDetailState(bookLoadData: ViewData.initial(), isLiked: false));

  Future<void> loadBookDetail(int bookId) async {
    emit(state.copyWith(bookLoadData: ViewData.loading()));
    try {
      final book = await _booksRepository.getBookById(bookId);
      final isLiked = _likedBooksRepository.isBookLiked(bookId);
      emit(
        state.copyWith(
          bookLoadData: ViewData.loaded(data: book),
          isLiked: isLiked,
        ),
      );
    } catch (e) {
      NetworkErrorHandler.logError(e, 'BookDetailCubit.loadBookDetail');
      emit(
        state.copyWith(
          bookLoadData: ViewData.error(
            message: NetworkErrorHandler.getUserFriendlyMessage(e),
          ),
        ),
      );
    }
  }

  Future<void> toggleBookLike() async {
    if (!state.bookLoadData.isHasData || state.bookLoadData.data == null) {
      return;
    }

    final book = state.bookLoadData.data!;
    try {
      final currentLikeStatus = _likedBooksRepository.isBookLiked(book.id);

      if (currentLikeStatus) {
        await _likedBooksRepository.unlikeBook(book.id);
      } else {
        await _likedBooksRepository.likeBook(book);
      }

      // Update the like status immediately
      emit(state.copyWith(isLiked: !currentLikeStatus));
    } catch (e) {
      emit(
        state.copyWith(
          bookLoadData: ViewData.error(
            message: NetworkErrorHandler.getUserFriendlyMessage(e),
            data: book,
          ),
        ),
      );
    }
  }

  bool isBookLiked() {
    return state.isLiked;
  }
}
