import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rock_paper_scissors/core/settings/app_settings.dart';
import 'package:rock_paper_scissors/core/settings/settings_cubit.dart';
import 'package:rock_paper_scissors/core/settings/settings_repository.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/difficulty.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/match_mode.dart';

class _MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  late _MockSettingsRepository repository;

  setUpAll(() => registerFallbackValue(const AppSettings()));

  setUp(() {
    repository = _MockSettingsRepository();
    when(() => repository.load()).thenReturn(const AppSettings());
    when(() => repository.save(any())).thenAnswer((_) async {});
  });

  test('starts from the stored settings', () {
    when(() => repository.load()).thenReturn(
      const AppSettings(soundOn: false, mode: MatchMode.endless),
    );

    expect(
      SettingsCubit(repository).state,
      const AppSettings(soundOn: false, mode: MatchMode.endless),
    );
  });

  blocTest<SettingsCubit, AppSettings>(
    'toggleLanguage switches English to Persian and saves it',
    build: () => SettingsCubit(repository),
    act: (cubit) => cubit.toggleLanguage(const Locale('en')),
    expect: () => [const AppSettings(locale: Locale('fa'))],
    verify: (_) => verify(
      () => repository.save(const AppSettings(locale: Locale('fa'))),
    ).called(1),
  );

  blocTest<SettingsCubit, AppSettings>(
    'toggleLanguage switches Persian to English',
    build: () => SettingsCubit(repository),
    act: (cubit) => cubit.toggleLanguage(const Locale('fa')),
    expect: () => [const AppSettings(locale: Locale('en'))],
  );

  blocTest<SettingsCubit, AppSettings>(
    'toggleSound flips the sound flag',
    build: () => SettingsCubit(repository),
    act: (cubit) => cubit
      ..toggleSound()
      ..toggleSound(),
    expect: () => [
      const AppSettings(soundOn: false),
      const AppSettings(),
    ],
  );

  blocTest<SettingsCubit, AppSettings>(
    'cycleThemeMode steps system, light, dark and back',
    build: () => SettingsCubit(repository),
    act: (cubit) => cubit
      ..cycleThemeMode()
      ..cycleThemeMode()
      ..cycleThemeMode(),
    expect: () => [
      const AppSettings(themeMode: ThemeMode.light),
      const AppSettings(themeMode: ThemeMode.dark),
      const AppSettings(),
    ],
  );

  blocTest<SettingsCubit, AppSettings>(
    'completeOnboarding is remembered once',
    build: () => SettingsCubit(repository),
    act: (cubit) => cubit
      ..completeOnboarding()
      ..completeOnboarding(),
    expect: () => [const AppSettings(onboardingSeen: true)],
    verify: (_) => verify(
      () => repository.save(const AppSettings(onboardingSeen: true)),
    ).called(1),
  );

  blocTest<SettingsCubit, AppSettings>(
    'selectMode and selectDifficulty update the choices',
    build: () => SettingsCubit(repository),
    act: (cubit) => cubit
      ..selectMode(MatchMode.endless)
      ..selectDifficulty(Difficulty.hard),
    expect: () => [
      const AppSettings(mode: MatchMode.endless),
      const AppSettings(mode: MatchMode.endless, difficulty: Difficulty.hard),
    ],
  );

  blocTest<SettingsCubit, AppSettings>(
    'selecting the current value neither emits nor saves',
    build: () => SettingsCubit(repository),
    act: (cubit) => cubit
      ..selectMode(MatchMode.bestOf5)
      ..selectDifficulty(Difficulty.normal),
    expect: () => <AppSettings>[],
    verify: (_) => verifyNever(() => repository.save(any())),
  );
}
