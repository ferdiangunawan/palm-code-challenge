part of 'book_detail_cubit.dart';

class BookDetailState extends Equatable {
  final ViewData<Book> bookLoadData;
  final bool isLiked;

  const BookDetailState({required this.bookLoadData, this.isLiked = false});

  BookDetailState copyWith({ViewData<Book>? bookLoadData, bool? isLiked}) {
    return BookDetailState(
      bookLoadData: bookLoadData ?? this.bookLoadData,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [bookLoadData, isLiked];
}
