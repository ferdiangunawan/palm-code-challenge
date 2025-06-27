import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:palm_code_challenge/data/models/index.dart';
import 'package:palm_code_challenge/presentation/shared/widgets/book_card.dart';
import 'package:palm_code_challenge/presentation/shared/widgets/skeletons.dart';

class SkeletonBookCard extends StatelessWidget {
  const SkeletonBookCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Create fake data for skeleton
    final fakeBook = Book(
      id: 0,
      title: 'Loading Book Title That Could Be Long',
      authors: [
        Author(name: 'Loading Author Name', birthYear: null, deathYear: null),
      ],
      subjects: ['Loading Subject'],
      bookshelves: [],
      languages: ['en'],
      copyright: false,
      mediaType: 'text',
      formats: {},
      downloadCount: 12345,
    );

    return Skeletonizer(
      ignoreContainers: true,
      enabled: true,
      child: BookCard(
        book: fakeBook,
        isLiked: false,
        onTap: () {},
        onLikeTap: () {},
      ),
    );
  }
}

class SkeletonBookCardAlternative extends StatelessWidget {
  const SkeletonBookCardAlternative({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Book image skeleton
          SkeletonImage(
            width: 60.w,
            height: 80.h,
            borderRadius: BorderRadius.circular(8.r),
          ),
          Gap(12.w),
          // Book details skeleton
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title lines
                SkeletonLine(width: double.infinity, height: 16),
                Gap(4.h),
                SkeletonLine(width: 200.w, height: 16),
                Gap(8.h),
                // Author line
                SkeletonLine(width: 150.w, height: 14),
                Gap(8.h),
                // Download count and subject
                Row(
                  children: [
                    SkeletonLine(width: 80.w, height: 12),
                    Gap(16.w),
                    SkeletonLine(width: 100.w, height: 12),
                  ],
                ),
              ],
            ),
          ),
          // Heart icon skeleton
          SkeletonAvatar(radius: 16.r, isCircular: true),
        ],
      ),
    );
  }
}

class SkeletonBookList extends StatelessWidget {
  final int itemCount;
  final bool useAlternative;

  const SkeletonBookList({
    super.key,
    this.itemCount = 5,
    this.useAlternative = false,
  });

  @override
  Widget build(BuildContext context) {
    // Check if the parent is a SliverToBoxAdapter
    final parentData =
        context.findAncestorWidgetOfExactType<SliverToBoxAdapter>();

    // If we're being used in a SliverToBoxAdapter, we need to use a Column instead of ListView
    if (parentData != null) {
      return Column(
        children: List.generate(
          itemCount,
          (index) => Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child:
                useAlternative
                    ? const SkeletonBookCardAlternative()
                    : const SkeletonBookCard(),
          ),
        ),
      );
    }

    // Otherwise, we can use ListView as before
    return ListView.builder(
      itemCount: itemCount,
      padding: EdgeInsets.symmetric(vertical: 8.h),
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child:
              useAlternative
                  ? const SkeletonBookCardAlternative()
                  : const SkeletonBookCard(),
        );
      },
    );
  }
}

/// A sliver version of SkeletonBookList that can be used directly in a [CustomScrollView]
/// without wrapping it in a [SliverToBoxAdapter].
class SliverSkeletonBookList extends StatelessWidget {
  final int itemCount;
  final bool useAlternative;

  const SliverSkeletonBookList({
    super.key,
    this.itemCount = 5,
    this.useAlternative = false,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child:
              useAlternative
                  ? const SkeletonBookCardAlternative()
                  : const SkeletonBookCard(),
        );
      }, childCount: itemCount),
    );
  }
}
