import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rock_paper_scissors/core/settings/app_settings.dart';
import 'package:rock_paper_scissors/core/settings/settings_repository.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/difficulty.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/match_mode.dart';

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

  void selectMode(MatchMode mode) => _update(state.copyWith(mode: mode));

  void selectDifficulty(Difficulty difficulty) =>
      _update(state.copyWith(difficulty: difficulty));

  void _update(AppSettings next) {
    if (next == state) return;
    emit(next);
    _repository.save(next);
  }
}
