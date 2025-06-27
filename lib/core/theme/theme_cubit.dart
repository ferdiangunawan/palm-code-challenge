import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  static const String _themeKey = 'theme_mode';

  ThemeCubit() : super(const ThemeState(themeMode: ThemeMode.system));

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themeKey) ?? ThemeMode.system.index;
    final themeMode = ThemeMode.values[themeIndex];
    emit(ThemeState(themeMode: themeMode));
  }

  Future<void> toggleTheme() async {
    final newThemeMode =
        state.themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, newThemeMode.index);

    emit(ThemeState(themeMode: newThemeMode));
  }

  Future<void> setTheme(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, themeMode.index);

    emit(ThemeState(themeMode: themeMode));
  }
}
