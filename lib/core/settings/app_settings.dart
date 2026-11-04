import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/difficulty.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/match_mode.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/opponent.dart';

/// App preferences remembered between launches.
final class AppSettings extends Equatable {
  const AppSettings({
    this.locale,
    this.soundOn = true,
    this.mode = MatchMode.bestOf5,
    this.difficulty = Difficulty.normal,
    this.opponent = Opponent.robot,
    this.themeMode = ThemeMode.system,
    this.onboardingSeen = false,
  });

  /// `null` follows the device language.
  final Locale? locale;
  final bool soundOn;
  final MatchMode mode;
  final Difficulty difficulty;
  final Opponent opponent;
  final ThemeMode themeMode;

  /// Whether the first-launch "how to play" slides were finished or skipped.
  final bool onboardingSeen;

  AppSettings copyWith({
    Locale? locale,
    bool? soundOn,
    MatchMode? mode,
    Difficulty? difficulty,
    Opponent? opponent,
    ThemeMode? themeMode,
    bool? onboardingSeen,
  }) {
    return AppSettings(
      locale: locale ?? this.locale,
      soundOn: soundOn ?? this.soundOn,
      mode: mode ?? this.mode,
      difficulty: difficulty ?? this.difficulty,
      opponent: opponent ?? this.opponent,
      themeMode: themeMode ?? this.themeMode,
      onboardingSeen: onboardingSeen ?? this.onboardingSeen,
    );
  }

  @override
  List<Object?> get props => [
        locale,
        soundOn,
        mode,
        difficulty,
        opponent,
        themeMode,
        onboardingSeen,
      ];
}
