import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palm_code_challenge/data/models/index.dart';

class BookDetailDescription extends StatelessWidget {
  final Book book;
  const BookDetailDescription({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    // Placeholder for book description, replace with actual field if available
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0).w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // show another information
          // show book shelf
          ...List.generate(
            book.bookshelves.length,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                book.bookshelves[index],
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
          SizedBox(height: 8.0.w),
          // show book description
          Text(
            book.formats['text/plain; charset=utf-8'] ??
                'No description available.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
