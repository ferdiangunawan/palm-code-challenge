import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palm_code_challenge/common/utils/index.dart';
import 'package:palm_code_challenge/data/models/index.dart';
import 'package:palm_code_challenge/domain/repositories/index.dart';

part 'liked_books_state.dart';

class LikedBooksCubit extends Cubit<LikedBooksState> {
  final LikedBooksRepository _likedBooksRepository;
  StreamSubscription<List<Book>>? _subscription;

  LikedBooksCubit(this._likedBooksRepository)
    : super(LikedBooksState(likedBooksLoadData: ViewData.initial()));

  void loadLikedBooks() {
    emit(state.copyWith(likedBooksLoadData: ViewData.loading()));

    final likedBooks = _likedBooksRepository.getLikedBooks();

    if (likedBooks.isEmpty) {
      emit(
        state.copyWith(
          likedBooksLoadData: ViewData.noData(message: 'No liked books yet'),
        ),
      );
    } else {
      emit(
        state.copyWith(likedBooksLoadData: ViewData.loaded(data: likedBooks)),
      );
    }

    // Watch for changes
    _subscription?.cancel();
    _subscription = _likedBooksRepository.watchLikedBooks().listen(
      (books) {
        if (books.isEmpty) {
          emit(
            state.copyWith(
              likedBooksLoadData: ViewData.noData(
                message: 'No liked books yet',
              ),
            ),
          );
        } else {
          emit(
            state.copyWith(likedBooksLoadData: ViewData.loaded(data: books)),
          );
        }
      },
      onError: (error) {
        NetworkErrorHandler.logError(error, 'LikedBooksCubit.watchLikedBooks');
        emit(
          state.copyWith(
            likedBooksLoadData: ViewData.error(
              message: NetworkErrorHandler.getUserFriendlyMessage(error),
            ),
          ),
        );
      },
    );
  }

  Future<void> unlikeBook(int bookId) async {
    try {
      await _likedBooksRepository.unlikeBook(bookId);
      // The stream will automatically update the UI
    } catch (e) {
      NetworkErrorHandler.logError(e, 'LikedBooksCubit.unlikeBook');
      emit(
        state.copyWith(
          likedBooksLoadData: ViewData.error(
            message: NetworkErrorHandler.getUserFriendlyMessage(e),
            data: state.likedBooksLoadData.data,
          ),
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
