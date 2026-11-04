import 'package:flutter/material.dart';
import 'package:rock_paper_scissors/core/l10n/l10n.dart';
import 'package:rock_paper_scissors/core/theme/app_motion.dart';
import 'package:rock_paper_scissors/core/theme/app_spacing.dart';
import 'package:rock_paper_scissors/core/theme/game_colors.dart';
import 'package:rock_paper_scissors/core/widgets/app_background.dart';
import 'package:rock_paper_scissors/core/widgets/chunky_button.dart';
import 'package:rock_paper_scissors/core/widgets/toy_surface.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/difficulty.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/move.dart';
import 'package:rock_paper_scissors/features/game/presentation/mappers/robot_look.dart';
import 'package:rock_paper_scissors/features/game/presentation/widgets/hand_art.dart';
import 'package:rock_paper_scissors/features/game/presentation/widgets/robot_avatar.dart';

/// Three "how to play" slides shown on first launch and from the help button.
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key, required this.onDone});

  /// Called when the player finishes or skips the slides.
  final VoidCallback onDone;

  static Route<void> route() {
    return MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (context) =>
          OnboardingPage(onDone: () => Navigator.of(context).pop()),
    );
  }

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  static const _slideCount = 3;

  final _controller = PageController();
  int _page = 0;

  bool get _isLast => _page == _slideCount - 1;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_isLast) {
      widget.onDone();
      return;
    }
    final duration = AppMotion.of(context, AppMotion.page);
    if (duration == Duration.zero) {
      _controller.jumpToPage(_page + 1);
    } else {
      _controller.nextPage(duration: duration, curve: AppMotion.pageEnter);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final slides = [
      _Slide(
        art: const _MovesArt(),
        title: l10n.onboardingMovesTitle,
        body: l10n.onboardingMovesBody,
      ),
      _Slide(
        art: const _RobotsArt(),
        title: l10n.onboardingRobotsTitle,
        body: l10n.onboardingRobotsBody(
          Difficulty.easy.robotName(context),
          Difficulty.hard.robotName(context),
        ),
      ),
      _Slide(
        art: const _TrophiesArt(),
        title: l10n.onboardingTrophiesTitle,
        body: l10n.onboardingTrophiesBody,
      ),
    ];

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: AnimatedOpacity(
                        opacity: _isLast ? 0 : 1,
                        duration: AppMotion.of(context, AppMotion.quick),
                        child: TextButton(
                          key: const Key('onboarding_skip'),
                          onPressed: _isLast ? null : widget.onDone,
                          child: Text(l10n.onboardingSkip),
                        ),
                      ),
                    ),
                    Expanded(
                      child: PageView(
                        controller: _controller,
                        onPageChanged: (page) => setState(() => _page = page),
                        children: slides,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _Dots(count: _slideCount, current: _page),
                    const SizedBox(height: AppSpacing.lg),
                    SizedBox(
                      width: double.infinity,
                      child: ChunkyButton(
                        key: const Key('onboarding_next'),
                        color: scheme.secondary,
                        onPressed: _next,
                        semanticLabel:
                            _isLast ? l10n.onboardingDone : l10n.onboardingNext,
                        child: Text(
                          _isLast ? l10n.onboardingDone : l10n.onboardingNext,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: scheme.onSecondary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  const _Slide({required this.art, required this.title, required this.body});

  final Widget art;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      children: [
        Expanded(
          child: Center(
            child: FittedBox(fit: BoxFit.scaleDown, child: art),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Semantics(
          header: true,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: scheme.onSurface,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          body,
          textAlign: TextAlign.center,
          style: theme.textTheme.titleMedium?.copyWith(
            color: scheme.onSurfaceVariant,
            fontWeight: FontWeight.w700,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.current});

  final int count;
  final int current;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final duration = AppMotion.of(context, AppMotion.quick);

    return Semantics(
      label: context.l10n.onboardingPage(current + 1, count),
      excludeSemantics: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var index = 0; index < count; index++)
            AnimatedContainer(
              duration: duration,
              curve: AppMotion.standardCurve,
              margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
              width: index == current ? 28 : 10,
              height: 10,
              decoration: BoxDecoration(
                color: index == current
                    ? scheme.primary
                    : scheme.primary.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
            ),
        ],
      ),
    );
  }
}

class _MovesArt extends StatelessWidget {
  const _MovesArt();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final arrow = Icon(
      Icons.arrow_forward_rounded,
      color: scheme.onSurfaceVariant,
      size: 32,
    );

    // Each arrow reads "beats": rock → scissors → paper.
    const chain = [Move.rock, Move.scissors, Move.paper];
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final move in chain) ...[
          if (move != chain.first) arrow,
          HandArt(move: move, size: 84),
        ],
      ],
    );
  }
}

class _RobotsArt extends StatelessWidget {
  const _RobotsArt();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (final difficulty in Difficulty.values) ...[
          if (difficulty != Difficulty.values.first)
            const SizedBox(width: AppSpacing.md),
          RobotAvatar(
            difficulty: difficulty,
            mood: RobotMood.happy,
            size: difficulty == Difficulty.normal ? 112 : 88,
          ),
        ],
      ],
    );
  }
}

class _TrophiesArt extends StatelessWidget {
  const _TrophiesArt();

  @override
  Widget build(BuildContext context) {
    final colors = GameColors.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ToyBadge(
          color: colors.star,
          size: 128,
          child: const Icon(
            Icons.emoji_events_rounded,
            color: Colors.white,
            size: 76,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < 3; i++)
              Icon(Icons.star_rounded, color: colors.star, size: 44),
          ],
        ),
      ],
    );
  }
}
