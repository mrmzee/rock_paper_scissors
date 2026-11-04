import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rock_paper_scissors/app.dart';
import 'package:rock_paper_scissors/core/settings/app_settings.dart';
import 'package:rock_paper_scissors/core/settings/settings_repository.dart';
import 'package:rock_paper_scissors/features/game/data/repositories/in_memory_stats_repository.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/difficulty.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/match_mode.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/move.dart';
import 'package:rock_paper_scissors/features/game/presentation/views/game_page.dart';
import 'package:rock_paper_scissors/features/game/presentation/widgets/hand_art.dart';
import 'package:rock_paper_scissors/features/game/presentation/widgets/hand_card.dart';
import 'package:rock_paper_scissors/features/stats/presentation/views/stats_page.dart';

import 'helpers/sequence_opponent_strategy.dart';

Widget _gameApp({
  Locale locale = const Locale('en'),
  MatchMode mode = MatchMode.endless,
  List<Move> robotMoves = const [Move.rock],
  Duration revealDelay = const Duration(milliseconds: 30),
}) {
  return RockPaperScissorsApp(
    settingsRepository: InMemorySettingsRepository(
      AppSettings(locale: locale),
    ),
    statsRepository: InMemoryStatsRepository(),
    opponentStrategy: SequenceOpponentStrategy(robotMoves),
    home: GamePage(
      mode: mode,
      difficulty: Difficulty.easy,
      revealDelay: revealDelay,
      resultDelay: const Duration(days: 1),
    ),
  );
}

Widget _homeApp({Locale locale = const Locale('en')}) {
  return RockPaperScissorsApp(
    settingsRepository: InMemorySettingsRepository(
      AppSettings(locale: locale),
    ),
    statsRepository: InMemoryStatsRepository(),
    opponentStrategy: SequenceOpponentStrategy(const []),
  );
}

void _setScreen(WidgetTester tester, Size size) {
  tester.view
    ..physicalSize = size
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

Finder _score(String key, String value) => find.descendant(
      of: find.byKey(Key(key)),
      matching: find.text(value),
    );

void main() {
  testWidgets('picking a move plays the round and updates the score',
      (tester) async {
    await tester.pumpWidget(_gameApp());

    expect(find.text('Pick your hand!'), findsOneWidget);
    expect(_score('player_score', '0'), findsOneWidget);

    await tester.tap(find.byKey(const Key('pick_paper')));
    await tester.pump();
    expect(find.text('Rock…'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 30));
    await tester.pump();

    expect(find.text('You win!'), findsOneWidget);
    expect(_score('player_score', '1'), findsOneWidget);
    expect(_score('robot_score', '0'), findsOneWidget);

    await tester.pump(const Duration(days: 1));
  });

  testWidgets('hands take the shape of each chant word', (tester) async {
    await tester.pumpWidget(
      _gameApp(revealDelay: const Duration(milliseconds: 900)),
    );

    Finder stageHands(Move move) => find.descendant(
          of: find.byType(HandCard),
          matching: find.byWidgetPredicate(
            (widget) => widget is HandArt && widget.move == move,
          ),
        );

    await tester.tap(find.byKey(const Key('pick_scissors')));
    await tester.pump();
    expect(find.text('Rock…'), findsOneWidget);
    expect(stageHands(Move.rock), findsNWidgets(2));

    for (final (word, move) in [
      ('Paper…', Move.paper),
      ('Scissors!', Move.scissors),
    ]) {
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text(word), findsOneWidget);
      expect(stageHands(move), findsNWidgets(2));
    }

    await tester.pump(const Duration(days: 1));
  });

  testWidgets('tapping the stage skips the round result', (tester) async {
    await tester.pumpWidget(_gameApp());

    await tester.tap(find.byKey(const Key('pick_rock')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 30));
    await tester.pump();
    expect(find.text('Draw!'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.text('Tap to continue'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Pick your hand!'), findsOneWidget);
    await tester.pump(const Duration(days: 1));
  });

  testWidgets('game screen fits a small phone and landscape in Persian',
      (tester) async {
    for (final size in const [Size(320, 568), Size(740, 360)]) {
      _setScreen(tester, size);
      await tester.pumpWidget(_gameApp(locale: const Locale('fa')));
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.text('دستت رو انتخاب کن!'), findsOneWidget);
      expect(
        Directionality.of(tester.element(find.byKey(const Key('pick_rock')))),
        TextDirection.rtl,
      );
    }
  });

  testWidgets('home fits on one screen without scrolling', (tester) async {
    for (final size in const [
      Size(320, 568),
      Size(390, 844),
      Size(740, 360),
      Size(1024, 768),
    ]) {
      _setScreen(tester, size);
      await tester.pumpWidget(_homeApp(locale: const Locale('fa')));
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.byType(Scrollable), findsNothing);
      final play = tester.getRect(find.byKey(const Key('play_button')));
      expect(play.bottom, lessThanOrEqualTo(size.height));
      expect(play.top, greaterThanOrEqualTo(0));
    }
  });

  testWidgets('home switches language and remembers choices', (tester) async {
    _setScreen(tester, const Size(360, 740));
    await tester.pumpWidget(_homeApp());

    expect(find.text('Play!'), findsOneWidget);

    await tester.tap(find.byKey(const Key('language_toggle')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('بزن بریم!'), findsOneWidget);

    await tester.tap(find.byKey(const Key('robot_hard')));
    await tester.pump();
    expect(
      tester.getSemantics(find.byKey(const Key('robot_hard'))),
      isSemantics(isSelected: true),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('home opens the game and the trophies page', (tester) async {
    _setScreen(tester, const Size(390, 844));
    await tester.pumpWidget(_homeApp());

    Future<void> settle() async {
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
    }

    await tester.tap(find.byKey(const Key('play_button')));
    await settle();
    expect(find.byType(GamePage), findsOneWidget);
    expect(find.text('Pick your hand!'), findsOneWidget);

    await tester.tap(find.byTooltip('Back'));
    await settle();
    expect(find.byType(GamePage), findsNothing);

    await tester.tap(find.byTooltip('My trophies'));
    await settle();
    expect(find.byType(StatsPage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
