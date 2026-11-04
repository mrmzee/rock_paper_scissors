import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/difficulty.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/match_mode.dart';

/// App preferences remembered between launches.
final class AppSettings extends Equatable {
  const AppSettings({
    this.locale,
    this.soundOn = true,
    this.mode = MatchMode.bestOf5,
    this.difficulty = Difficulty.normal,
    this.themeMode = ThemeMode.system,
  });

  /// `null` follows the device language.
  final Locale? locale;
  final bool soundOn;
  final MatchMode mode;
  final Difficulty difficulty;
  final ThemeMode themeMode;

  AppSettings copyWith({
    Locale? locale,
    bool? soundOn,
    MatchMode? mode,
    Difficulty? difficulty,
    ThemeMode? themeMode,
  }) {
    return AppSettings(
      locale: locale ?? this.locale,
      soundOn: soundOn ?? this.soundOn,
      mode: mode ?? this.mode,
      difficulty: difficulty ?? this.difficulty,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  List<Object?> get props => [locale, soundOn, mode, difficulty, themeMode];
}
