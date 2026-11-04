import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rock_paper_scissors/app.dart';
import 'package:rock_paper_scissors/core/settings/app_settings.dart';
import 'package:rock_paper_scissors/core/settings/settings_repository.dart';
import 'package:rock_paper_scissors/features/game/data/repositories/in_memory_stats_repository.dart';
import 'package:rock_paper_scissors/features/home/presentation/views/home_page.dart';
import 'package:rock_paper_scissors/features/onboarding/presentation/views/onboarding_page.dart';

import '../../helpers/sequence_opponent_strategy.dart';

void main() {
  Future<InMemorySettingsRepository> pumpApp(
    WidgetTester tester, {
    bool onboardingSeen = false,
    bool reduceMotion = false,
  }) async {
    tester.view
      ..physicalSize = const Size(390, 844)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final settings = InMemorySettingsRepository(
      AppSettings(locale: const Locale('en'), onboardingSeen: onboardingSeen),
    );
    await tester.pumpWidget(
      MediaQuery(
        data: MediaQueryData(
          size: const Size(390, 844),
          disableAnimations: reduceMotion,
        ),
        child: RockPaperScissorsApp(
          settingsRepository: settings,
          statsRepository: InMemoryStatsRepository(),
          opponentStrategy: SequenceOpponentStrategy(const []),
        ),
      ),
    );
    await tester.pump();
    return settings;
  }

  Future<void> tapAndWait(WidgetTester tester, Finder finder) async {
    await tester.tap(finder);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
  }

  testWidgets('first launch walks through the slides into home',
      (tester) async {
    final settings = await pumpApp(tester);

    expect(find.byType(OnboardingPage), findsOneWidget);
    expect(find.text('Pick your hand'), findsOneWidget);

    await tapAndWait(tester, find.byKey(const Key('onboarding_next')));
    expect(find.text('Choose a robot'), findsOneWidget);
    expect(
      find.text('Robo Jr. plays for fun. Grumpy Robo learns your tricks!'),
      findsOneWidget,
    );

    await tapAndWait(tester, find.byKey(const Key('onboarding_next')));
    expect(find.text('Win stars and trophies'), findsOneWidget);
    expect(find.text("Let's play!"), findsOneWidget);

    await tapAndWait(tester, find.byKey(const Key('onboarding_next')));
    expect(find.byType(OnboardingPage), findsNothing);
    expect(find.byType(HomePage), findsOneWidget);
    expect(settings.load().onboardingSeen, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('skip goes straight home, also with reduced motion',
      (tester) async {
    final settings = await pumpApp(tester, reduceMotion: true);

    await tapAndWait(tester, find.byKey(const Key('onboarding_next')));
    expect(find.text('Choose a robot'), findsOneWidget);

    await tapAndWait(tester, find.byKey(const Key('onboarding_skip')));
    expect(find.byType(HomePage), findsOneWidget);
    expect(settings.load().onboardingSeen, isTrue);
  });

  testWidgets('help button reopens the slides and returns home',
      (tester) async {
    await pumpApp(tester, onboardingSeen: true);
    expect(find.byType(OnboardingPage), findsNothing);

    await tapAndWait(tester, find.byTooltip('How to play'));
    expect(find.byType(OnboardingPage), findsOneWidget);

    await tapAndWait(tester, find.byKey(const Key('onboarding_skip')));
    expect(find.byType(OnboardingPage), findsNothing);
    expect(find.byType(HomePage), findsOneWidget);
  });
}
