import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/difficulty.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/match_mode.dart';

/// App preferences remembered between launches.
final class AppSettings extends Equatable {
  const AppSettings({
    this.locale,
    this.soundOn = true,
    this.mode = MatchMode.bestOf5,
    this.difficulty = Difficulty.normal,
  });

  /// `null` follows the device language.
  final Locale? locale;
  final bool soundOn;
  final MatchMode mode;
  final Difficulty difficulty;

  AppSettings copyWith({
    Locale? locale,
    bool? soundOn,
    MatchMode? mode,
    Difficulty? difficulty,
  }) {
    return AppSettings(
      locale: locale ?? this.locale,
      soundOn: soundOn ?? this.soundOn,
      mode: mode ?? this.mode,
      difficulty: difficulty ?? this.difficulty,
    );
  }

  @override
  List<Object?> get props => [locale, soundOn, mode, difficulty];
}
