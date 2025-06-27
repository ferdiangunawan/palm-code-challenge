import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palm_code_challenge/core/theme/index.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final isDark = state.themeMode == ThemeMode.dark;
        return IconButton(
          onPressed: () {
            context.read<ThemeCubit>().toggleTheme();
          },
          icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode, size: 28.0),
          tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
        );
      },
    );
  }
}
