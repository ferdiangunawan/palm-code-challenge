import 'package:flutter/material.dart';

class NoDataDisplay extends StatelessWidget {
  const NoDataDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 64.0, color: Colors.grey),
          const SizedBox(height: 16.0),
          Text(
            'No books found',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8.0),
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
