import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rock_paper_scissors/app.dart';
import 'package:rock_paper_scissors/core/settings/app_settings.dart';
import 'package:rock_paper_scissors/core/settings/settings_repository.dart';
import 'package:rock_paper_scissors/features/game/data/repositories/in_memory_stats_repository.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/difficulty.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/move.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/player_stats.dart';
import 'package:rock_paper_scissors/features/stats/presentation/views/stats_page.dart';

void main() {
  const stats = PlayerStats(
    matchesPlayed: 3,
    matchesWon: 2,
    matchesLost: 1,
    roundsWon: 6,
    roundsDrawn: 1,
    roundsLost: 3,
    bestStreak: 3,
    currentStreak: 1,
    movesPlayed: {Move.rock: 2, Move.scissors: 8},
    roundsPlayedBy: {Difficulty.hard: 10},
    roundsWonBy: {Difficulty.hard: 6},
  );

  Future<InMemoryStatsRepository> pumpStats(
    WidgetTester tester, [
    PlayerStats initial = stats,
  ]) async {
    tester.view
      ..physicalSize = const Size(390, 1400)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final repository = InMemoryStatsRepository(initial);
    await tester.pumpWidget(
      RockPaperScissorsApp(
        settingsRepository: InMemorySettingsRepository(
          const AppSettings(locale: Locale('en')),
        ),
        statsRepository: repository,
        home: const StatsPage(),
      ),
    );
    await tester.pump();
    return repository;
  }

  testWidgets('shows favorite hand and win rate per robot', (tester) async {
    await pumpStats(tester);

    expect(find.text('Favorite hand'), findsOneWidget);
    expect(find.text('Scissors'), findsOneWidget);
    expect(find.text('8 times'), findsOneWidget);
    expect(find.text('Against each robot'), findsOneWidget);
    expect(find.text('60%'), findsWidgets);
    expect(find.text('Not played yet'), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });

  testWidgets('reset asks first and then clears the stats', (tester) async {
    final repository = await pumpStats(tester);

    Future<void> tapAndWait(Finder finder) async {
      await tester.tap(finder);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
    }

    await tapAndWait(find.byKey(const Key('reset_stats')));
    await tapAndWait(find.text('Cancel'));
    expect(await repository.load(), stats);

    await tapAndWait(find.byKey(const Key('reset_stats')));
    await tapAndWait(find.byKey(const Key('confirm_reset_stats')));

    expect(await repository.load(), const PlayerStats());
    expect(find.text('Play a game to win trophies!'), findsOneWidget);
    expect(find.byKey(const Key('reset_stats')), findsNothing);
  });

  testWidgets('no reset button when there is nothing to reset', (tester) async {
    await pumpStats(tester, const PlayerStats());

    expect(find.byKey(const Key('reset_stats')), findsNothing);
  });
}
