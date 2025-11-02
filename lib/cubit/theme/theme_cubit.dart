import 'package:advance_e_commerce_app/cubit/theme/theme_state.dart';
import 'package:advance_e_commerce_app/repository/provider/theme_repository.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class ThemeCubit extends Cubit<ThemeState> with HydratedMixin {
  final ThemeRepository repository;

  ThemeCubit({required this.repository}) : super(ThemeLightState()) {
    hydrate();
    _loadTheme();
  }

  /// Load theme from repository
  Future<void> _loadTheme() async {
    final isDarkMode = await repository.isDarkMode();
    if (isDarkMode) {
      emit(ThemeDarkState());
    } else {
      emit(ThemeLightState());
    }
  }

  /// Toggle between light and dark theme
  Future<void> toggleTheme() async {
    final currentIsDark = state.themeMode == ThemeMode.dark;
    final newIsDark = !currentIsDark;
    
    // Save to repository
    await repository.saveTheme(isDarkMode: newIsDark);
    
    // Emit new state
    if (newIsDark) {
      emit(ThemeDarkState());
    } else {
      emit(ThemeLightState());
    }
  }

  /// Set theme to light
  Future<void> setLightTheme() async {
    await repository.saveTheme(isDarkMode: false);
    emit(ThemeLightState());
  }

  /// Set theme to dark
  Future<void> setDarkTheme() async {
    await repository.saveTheme(isDarkMode: true);
    emit(ThemeDarkState());
  }

  /// Restore from Hydrated storage
  @override
  ThemeState? fromJson(Map<String, dynamic> json) {
    try {
      final isDarkMode = json['isDarkMode'] as bool? ?? false;
      return isDarkMode ? ThemeDarkState() : ThemeLightState();
    } catch (e) {
      return ThemeLightState();
    }
  }

  /// Save to Hydrated storage
  @override
  Map<String, dynamic>? toJson(ThemeState state) {
    return {
      'isDarkMode': state.themeMode == ThemeMode.dark,
    };
  }
}

