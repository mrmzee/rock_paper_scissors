import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rock_paper_scissors/core/settings/app_settings.dart';
import 'package:rock_paper_scissors/core/settings/settings_repository.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/difficulty.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/match_mode.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/opponent.dart';

final class SettingsCubit extends Cubit<AppSettings> {
  SettingsCubit(this._repository) : super(_repository.load());

  final SettingsRepository _repository;

  /// Flips between Persian and English, starting from what is on screen.
  void toggleLanguage(Locale current) {
    final next =
        current.languageCode == 'fa' ? const Locale('en') : const Locale('fa');
    _update(state.copyWith(locale: next));
  }

  void toggleSound() => _update(state.copyWith(soundOn: !state.soundOn));

  /// Steps through system → light → dark → system.
  void cycleThemeMode() {
    final next = switch (state.themeMode) {
      ThemeMode.system => ThemeMode.light,
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.system,
    };
    _update(state.copyWith(themeMode: next));
  }

  void completeOnboarding() => _update(state.copyWith(onboardingSeen: true));

  void selectMode(MatchMode mode) => _update(state.copyWith(mode: mode));

  /// Picking a robot also switches back from pass-and-play.
  void selectDifficulty(Difficulty difficulty) => _update(
        state.copyWith(difficulty: difficulty, opponent: Opponent.robot),
      );

  void playWithFriend() => _update(state.copyWith(opponent: Opponent.friend));

  void _update(AppSettings next) {
    if (next == state) return;
    emit(next);
    _repository.save(next);
  }
}
