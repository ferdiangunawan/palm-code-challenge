part of 'liked_books_cubit.dart';

class LikedBooksState extends Equatable {
  final ViewData<List<Book>> likedBooksLoadData;

  const LikedBooksState({required this.likedBooksLoadData});

  LikedBooksState copyWith({ViewData<List<Book>>? likedBooksLoadData}) {
    return LikedBooksState(
      likedBooksLoadData: likedBooksLoadData ?? this.likedBooksLoadData,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [likedBooksLoadData];
}
