import 'package:flutter/material.dart';
import 'package:palm_code_challenge/presentation/home/widgets/theme_toggle_button.dart';

class HeaderDelegate extends SliverPersistentHeaderDelegate {
  final String title;

  HeaderDelegate({required this.title});

  @override
  double get minExtent => 50.0;

  @override
  double get maxExtent => 60.0;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final theme = Theme.of(context);

    return Container(
      color: theme.scaffoldBackgroundColor,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ),
              ),
              const ThemeToggleButton(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
