import 'package:flutter/material.dart';

class SearchBarDelegate extends SliverPersistentHeaderDelegate {
  final TextEditingController searchController;
  final Function(String) onChanged;
  final VoidCallback onClear;

  SearchBarDelegate({
    required this.searchController,
    required this.onChanged,
    required this.onClear,
  });

  @override
  double get minExtent => 80.0;

  @override
  double get maxExtent => 80.0;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Search books...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon:
                searchController.text.isNotEmpty
                    ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: onClear,
                    )
                    : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
