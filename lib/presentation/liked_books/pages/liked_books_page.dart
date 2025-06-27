import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:palm_code_challenge/data/models/index.dart';
import 'package:palm_code_challenge/presentation/liked_books/cubit/index.dart';
import 'package:palm_code_challenge/presentation/shared/widgets/index.dart';

class LikedBooksPage extends StatefulWidget {
  const LikedBooksPage({super.key});

  @override
  State<LikedBooksPage> createState() => _LikedBooksPageState();
}

class _LikedBooksPageState extends State<LikedBooksPage> {
  @override
  void initState() {
    super.initState();
    context.read<LikedBooksCubit>().loadLikedBooks();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        centerTitle: false,
        elevation: 0,
        title: Text(
          'Liked Books',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
          ),
        ),
      ),
      body: BlocBuilder<LikedBooksCubit, LikedBooksState>(
        builder: (context, state) {
          return ViewDataBuilder<List<Book>>(
            viewData: state.likedBooksLoadData,
            onLoading: (context) => const SkeletonBookList(),
            onData: (context, books) {
              return ListView.builder(
                itemCount: books.length,
                itemBuilder: (context, index) {
                  final book = books[index];
                  return BookCard(
                    book: book,
                    isLiked: true, // All books in this screen are liked
                    onTap: () {
                      context.push('/book/${book.id}', extra: book);
                    },
                    onLikeTap: () {
                      context.read<LikedBooksCubit>().unlikeBook(book.id);
                    },
                  );
                },
              );
            },
            onNoData:
                (context, message) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite_border,
                        size: 64.sp,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'No liked books yet',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Tap the heart icon on any book to add it here',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
          );
        },
      ),
    );
  }
}
