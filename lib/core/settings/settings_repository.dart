import 'package:flutter/material.dart';
import 'package:rock_paper_scissors/core/settings/app_settings.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/difficulty.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/match_mode.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class SettingsRepository {
  AppSettings load();

  Future<void> save(AppSettings settings);
}

final class InMemorySettingsRepository implements SettingsRepository {
  InMemorySettingsRepository([this._settings = const AppSettings()]);

  AppSettings _settings;

  @override
  AppSettings load() => _settings;

  @override
  Future<void> save(AppSettings settings) async => _settings = settings;
}

final class PreferencesSettingsRepository implements SettingsRepository {
  PreferencesSettingsRepository(this._prefs);

  final SharedPreferences _prefs;

  static const _localeKey = 'settings.locale';
  static const _soundKey = 'settings.sound';
  static const _modeKey = 'settings.mode';
  static const _difficultyKey = 'settings.difficulty';
  static const _themeModeKey = 'settings.themeMode';

  @override
  AppSettings load() {
    final localeCode = _prefs.getString(_localeKey);
    return AppSettings(
      locale: localeCode == null ? null : Locale(localeCode),
      soundOn: _prefs.getBool(_soundKey) ?? true,
      mode: _byName(MatchMode.values, _prefs.getString(_modeKey)) ??
          MatchMode.bestOf5,
      difficulty:
          _byName(Difficulty.values, _prefs.getString(_difficultyKey)) ??
              Difficulty.normal,
      themeMode: _byName(ThemeMode.values, _prefs.getString(_themeModeKey)) ??
          ThemeMode.system,
    );
  }

  @override
  Future<void> save(AppSettings settings) async {
    final locale = settings.locale;
    if (locale == null) {
      await _prefs.remove(_localeKey);
    } else {
      await _prefs.setString(_localeKey, locale.languageCode);
    }
    await _prefs.setBool(_soundKey, settings.soundOn);
    await _prefs.setString(_modeKey, settings.mode.name);
    await _prefs.setString(_difficultyKey, settings.difficulty.name);
    await _prefs.setString(_themeModeKey, settings.themeMode.name);
  }

  static T? _byName<T extends Enum>(List<T> values, String? name) {
    for (final value in values) {
      if (value.name == name) return value;
    }
    return null;
  }
}
