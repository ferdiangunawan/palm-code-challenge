import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palm_code_challenge/core/index.dart';
import 'package:palm_code_challenge/data/models/index.dart';
import 'package:palm_code_challenge/presentation/book_detail/cubit/index.dart';
import 'package:palm_code_challenge/presentation/shared/widgets/index.dart';
import 'package:palm_code_challenge/presentation/book_detail/widgets/book_detail_content.dart';
import 'package:palm_code_challenge/presentation/book_detail/widgets/book_detail_error.dart';

class BookDetailPage extends StatelessWidget {
  final int bookId;
  final Book? book;

  const BookDetailPage({super.key, required this.bookId, this.book});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<BookDetailCubit>()..loadBookDetail(bookId),
      child: Scaffold(
        body: BlocBuilder<BookDetailCubit, BookDetailState>(
          builder: (context, state) {
            return ViewDataBuilder<Book>(
              viewData: state.bookLoadData,
              onData:
                  (context, bookDetail) =>
                      BookDetailContent(bookDetail: bookDetail),
              onLoading: (context) => const SkeletonBookDetail(),
              onError: (context, message) => BookDetailError(message: message),
            );
          },
        ),
      ),
    );
  }
}
