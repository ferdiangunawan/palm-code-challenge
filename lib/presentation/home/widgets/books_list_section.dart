import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:palm_code_challenge/presentation/home/cubit/home_cubit.dart';
import 'package:palm_code_challenge/presentation/shared/widgets/index.dart';

class BooksListSection extends StatelessWidget {
  final HomeState state;

  const BooksListSection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        if (index >= state.books.length) {
          if (state.isLoadingMore) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (!state.hasReachedMax) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) {
                context.read<HomeCubit>().loadMoreBooks();
              }
            });
            return const SizedBox.shrink();
          }
          return const SizedBox.shrink();
        }

        final book = state.books[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: BookCard(
            book: book,
            isLiked: state.likedBookIds.contains(book.id),
            onTap: () {
              context.push('/book/${book.id}', extra: book);
            },
            onLikeTap: () {
              context.read<HomeCubit>().toggleBookLike(book);
            },
          ),
        );
      }, childCount: state.books.length + (state.hasReachedMax ? 0 : 1)),
    );
  }
}
