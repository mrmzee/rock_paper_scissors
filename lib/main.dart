import 'package:flutter/material.dart';
import 'package:rock_paper_scissors/app.dart';
import 'package:rock_paper_scissors/core/audio/sound_service.dart';
import 'package:rock_paper_scissors/core/settings/settings_repository.dart';
import 'package:rock_paper_scissors/features/game/data/repositories/adaptive_opponent_strategy.dart';
import 'package:rock_paper_scissors/features/game/data/repositories/preferences_stats_repository.dart';
import 'package:rock_paper_scissors/features/game/domain/usecases/play_round.dart';
import 'package:rock_paper_scissors/features/game/domain/usecases/record_match_stats.dart';
import 'package:rock_paper_scissors/features/home/presentation/views/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final statsRepository = PreferencesStatsRepository(prefs);
  final playRound = PlayRound(AdaptiveOpponentStrategy());
  final recordMatchStats = RecordMatchStats(statsRepository);

  runApp(
    RockPaperScissorsApp(
      settingsRepository: PreferencesSettingsRepository(prefs),
      soundService: AudioSoundService(),
      home: HomePage(
        playRound: playRound,
        recordMatchStats: recordMatchStats,
        statsRepository: statsRepository,
      ),
    ),
  );
}
