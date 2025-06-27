import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class NoDataDisplay extends StatelessWidget {
  const NoDataDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 64.0, color: Colors.grey),
          const Gap(16.0),
          Text(
            'No books found',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const Gap(8.0),
          Text(
            'Try adjusting your search terms',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
