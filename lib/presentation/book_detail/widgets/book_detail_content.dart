import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../index.dart';

class BookDetailContent extends StatelessWidget {
  final Book bookDetail;
  const BookDetailContent({super.key, required this.bookDetail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<BookDetailCubit, BookDetailState>(
        builder: (context, state) {
          final isLiked = state.isLiked;
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 250.h,
                pinned: true,
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? Theme.of(
                        context,
                      ).colorScheme.surface.withValues(alpha: 0.7)
                    : Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.4),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => context.pop(),
                ),
                flexibleSpace: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                    child: FlexibleSpaceBar(
                      title: Text(
                        bookDetail.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      centerTitle: false,
                      titlePadding: EdgeInsets.only(left: 56.w, bottom: 16.h),
                      background: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          showPhotoViewer(
                            context: context,
                            imageUrl: bookDetail.imageUrl,
                            heroTag: 'book_${bookDetail.id}_1',
                          );
                        },
                        child: Hero(
                          tag: 'book_${bookDetail.id}_1',
                          child: SafeCachedNetworkImage(
                            imageUrl: bookDetail.imageUrl,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                actions: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    child: AnimatedHeart(
                      size: 28.w,
                      isLiked: isLiked,
                      onTap: () =>
                          context.read<BookDetailCubit>().toggleBookLike(),
                    ),
                  ),
                ],
              ),
              SliverToBoxAdapter(child: BookDetailInfo(book: bookDetail)),
              SliverToBoxAdapter(
                child: BookDetailDescription(book: bookDetail),
              ),
              // Add more widgets/slivers as needed
            ],
          );
        },
      ),
    );
  }
}
