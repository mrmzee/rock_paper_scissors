import 'package:flutter/material.dart';
import 'package:rock_paper_scissors/app.dart';
import 'package:rock_paper_scissors/core/audio/sound_service.dart';
import 'package:rock_paper_scissors/core/settings/settings_repository.dart';
import 'package:rock_paper_scissors/features/achievements/data/repositories/preferences_achievements_repository.dart';
import 'package:rock_paper_scissors/features/game/data/repositories/adaptive_opponent_strategy.dart';
import 'package:rock_paper_scissors/features/game/data/repositories/preferences_stats_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  runApp(
    RockPaperScissorsApp(
      settingsRepository: PreferencesSettingsRepository(prefs),
      statsRepository: PreferencesStatsRepository(prefs),
      achievementsRepository: PreferencesAchievementsRepository(prefs),
      opponentStrategy: AdaptiveOpponentStrategy(),
      soundService: AudioSoundService(),
    ),
  );
}
