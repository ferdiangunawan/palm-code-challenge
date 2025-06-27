import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:palm_code_challenge/presentation/shared/widgets/skeleton_info_card.dart';

class SkeletonBookDetail extends StatelessWidget {
  const SkeletonBookDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.h,
            pinned: true,
            backgroundColor:
                Theme.of(context).brightness == Brightness.dark
                    ? Theme.of(
                      context,
                    ).colorScheme.surface.withValues(alpha: 0.7)
                    : Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.4),
            flexibleSpace: FlexibleSpaceBar(
              title: Skeletonizer(
                enabled: true,
                child: Text(
                  'Loading Book Title',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              centerTitle: false,
              titlePadding: EdgeInsets.only(left: 56.w, bottom: 16.h),
              background: Skeletonizer(
                enabled: true,
                child: Container(
                  color: Colors.grey[200],
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
            actions: [
              Container(
                padding: EdgeInsets.all(8.w),
                child: Icon(
                  Icons.favorite_border,
                  size: 32.sp,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Skeletonizer(
              enabled: true,
              ignoreContainers: true,
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Loading Book Title That Could Be Very Long',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Gap(8.h),
                    Text(
                      'by Loading Author Name, Another Author',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    Gap(16.h),
                    SkeletonInfoCard(
                      title: 'Download Count',
                      value: '12,345 downloads',
                      icon: Icons.download,
                    ),
                    Gap(8.h),
                    SkeletonInfoCard(
                      title: 'Languages',
                      value: 'English, French',
                      icon: Icons.language,
                    ),
                    Gap(16.h),
                    Text(
                      'Subjects',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Gap(8.h),
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: List.generate(3, (index) {
                        return Chip(
                          label: Text('Loading Subject ${index + 1}'),
                          backgroundColor:
                              Theme.of(context).colorScheme.primaryContainer,
                        );
                      }),
                    ),
                    Gap(16.h),
                    Text(
                      'Bookshelves',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Gap(8.h),
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: List.generate(2, (index) {
                        return Chip(
                          label: Text('Loading Bookshelf ${index + 1}'),
                          backgroundColor:
                              Theme.of(context).colorScheme.secondaryContainer,
                        );
                      }),
                    ),
                    Gap(32.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
