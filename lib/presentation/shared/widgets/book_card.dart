import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palm_code_challenge/data/models/index.dart';
import 'package:palm_code_challenge/presentation/shared/widgets/index.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final bool isLiked;
  final VoidCallback? onTap;
  final VoidCallback? onLikeTap;

  const BookCard({
    super.key,
    required this.book,
    required this.isLiked,
    this.onTap,
    this.onLikeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  showPhotoViewer(
                    context: context,
                    imageUrl: book.imageUrl,
                    heroTag: 'photo_${book.id}',
                  );
                },
                child: Hero(
                  tag: 'book_${book.id}',
                  child: SafeCachedNetworkImage(
                    imageUrl: book.imageUrl,
                    width: 60.w,
                    height: 80.h,
                    fit: BoxFit.cover,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      book.authorsString,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                        fontSize: 14.sp,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Icon(
                          Icons.download,
                          size: 16.sp,
                          color: Colors.grey[600],
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '${book.downloadCount}',
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                            fontSize: 12.sp,
                          ),
                        ),
                        if (book.subjects.isNotEmpty) ...[
                          SizedBox(width: 16.w),
                          Flexible(
                            child: Text(
                              book.primarySubject,
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall?.copyWith(
                                color: Colors.blue[600],
                                fontSize: 12.sp,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(8.w),
                child: AnimatedHeart(
                  isLiked: isLiked,
                  onTap: onLikeTap,
                  size: 28.sp,
                  likedColor: Colors.red,
                  unlikedColor: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
