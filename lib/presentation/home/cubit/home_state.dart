part of 'home_cubit.dart';

class HomeState extends Equatable {
  final ViewData<List<Book>> booksLoadData;
  final List<Book> books;
  final ParamGetBooks params;
  final bool hasReachedMax;
  final bool isLoadingMore;
  final Set<int> likedBookIds;

  const HomeState({
    required this.booksLoadData,
    required this.books,
    required this.params,
    required this.hasReachedMax,
    required this.isLoadingMore,
    this.likedBookIds = const {},
  });

  HomeState copyWith({
    ViewData<List<Book>>? booksLoadData,
    List<Book>? books,
    ParamGetBooks? params,
    bool? hasReachedMax,
    bool? isLoadingMore,
    Set<int>? likedBookIds,
  }) {
    return HomeState(
      booksLoadData: booksLoadData ?? this.booksLoadData,
      books: books ?? this.books,
      params: params ?? this.params,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      likedBookIds: likedBookIds ?? this.likedBookIds,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
    booksLoadData,
    books,
    params,
    hasReachedMax,
    isLoadingMore,
    likedBookIds,
  ];
}
