import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:palm_code_challenge/data/models/index.dart';

class BookDetailInfo extends StatelessWidget {
  final Book book;
  const BookDetailInfo({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(book.title, style: Theme.of(context).textTheme.titleLarge),
          const Gap(8),
          Text(
            'by ${book.authors.isNotEmpty ? book.authors.map((a) => a.name).join(', ') : 'Unknown'}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const Gap(12),
          if (book.subjects.isNotEmpty)
            Wrap(
              spacing: 8,
              children:
                  book.subjects
                      .take(3)
                      .map((s) => Chip(label: Text(s)))
                      .toList(),
            ),
          const Gap(12),
          Text('Language: ${book.languages.join(", ")}'),
          const Gap(8),
          Text('Downloads: ${book.downloadCount}'),
        ],
      ),
    );
  }
}
