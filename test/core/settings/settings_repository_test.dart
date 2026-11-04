import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rock_paper_scissors/core/settings/app_settings.dart';
import 'package:rock_paper_scissors/core/settings/settings_repository.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/difficulty.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/match_mode.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/opponent.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('PreferencesSettingsRepository', () {
    Future<PreferencesSettingsRepository> build([
      Map<String, Object> values = const {},
    ]) async {
      SharedPreferences.setMockInitialValues(values);
      return PreferencesSettingsRepository(
        await SharedPreferences.getInstance(),
      );
    }

    test('returns defaults when nothing is stored', () async {
      final repository = await build();

      expect(repository.load(), const AppSettings());
    });

    test('round-trips saved settings', () async {
      final repository = await build();
      const settings = AppSettings(
        locale: Locale('fa'),
        soundOn: false,
        mode: MatchMode.endless,
        difficulty: Difficulty.hard,
        opponent: Opponent.friend,
        themeMode: ThemeMode.dark,
        onboardingSeen: true,
      );

      await repository.save(settings);

      expect(repository.load(), settings);
    });

    test('clears the locale to follow the device language', () async {
      final repository = await build({'settings.locale': 'fa'});

      await repository.save(const AppSettings());

      expect(repository.load().locale, isNull);
    });

    test('falls back to defaults for unknown stored values', () async {
      final repository = await build({
        'settings.mode': 'bestOf99',
        'settings.difficulty': 'impossible',
        'settings.themeMode': 'sepia',
        'settings.opponent': 'cat',
      });

      final settings = repository.load();
      expect(settings.mode, MatchMode.bestOf5);
      expect(settings.difficulty, Difficulty.normal);
      expect(settings.themeMode, ThemeMode.system);
      expect(settings.opponent, Opponent.robot);
    });
  });

  test('InMemorySettingsRepository keeps the last saved value', () async {
    final repository = InMemorySettingsRepository();
    const settings = AppSettings(soundOn: false);

    await repository.save(settings);

    expect(repository.load(), settings);
  });
}
