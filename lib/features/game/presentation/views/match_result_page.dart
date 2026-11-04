import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:rock_paper_scissors/core/audio/sound_service.dart';
import 'package:rock_paper_scissors/core/l10n/l10n.dart';
import 'package:rock_paper_scissors/core/theme/app_motion.dart';
import 'package:rock_paper_scissors/core/theme/app_spacing.dart';
import 'package:rock_paper_scissors/core/theme/game_colors.dart';
import 'package:rock_paper_scissors/core/widgets/app_background.dart';
import 'package:rock_paper_scissors/core/widgets/chunky_button.dart';
import 'package:rock_paper_scissors/core/widgets/toy_surface.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/match.dart';
import 'package:rock_paper_scissors/features/game/presentation/mappers/robot_look.dart';
import 'package:rock_paper_scissors/features/game/presentation/widgets/player_badge.dart';
import 'package:rock_paper_scissors/features/game/presentation/widgets/robot_avatar.dart';

enum MatchResultAction { playAgain, home }

/// Full-screen celebration (or consolation) after a 3-star match.
class MatchResultPage extends StatefulWidget {
  const MatchResultPage({super.key, required this.match});

  final Match match;

  static Route<MatchResultAction> route(Match match) {
    return PageRouteBuilder<MatchResultAction>(
      transitionDuration: AppMotion.page,
      reverseTransitionDuration: AppMotion.page,
      pageBuilder: (_, __, ___) => MatchResultPage(match: match),
      transitionsBuilder: (context, animation, _, child) {
        if (AppMotion.reduced(context)) return child;
        final curved = CurvedAnimation(
          parent: animation,
          curve: AppMotion.pageEnter,
        );
        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.92, end: 1).animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  @override
  State<MatchResultPage> createState() => _MatchResultPageState();
}

class _MatchResultPageState extends State<MatchResultPage> {
  final _confetti = ConfettiController(duration: const Duration(seconds: 2));

  bool get _won => widget.match.playerWon == true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.playSfx(_won ? Sfx.matchWin : Sfx.matchLose);
      if (_won && !AppMotion.reduced(context)) _confetti.play();
    });
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final colors = GameColors.of(context);
    final l10n = context.l10n;
    final match = widget.match;
    final robotName = match.difficulty.robotName(context);

    final title = _won ? l10n.matchWinTitle : l10n.matchLoseTitle(robotName);
    final subtitle = _won ? l10n.matchWinSubtitle : l10n.matchLoseSubtitle;

    return Scaffold(
      body: AppBackground(
        child: Stack(
          children: [
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.xlg),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 460),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.4, end: 1),
                            duration:
                                AppMotion.of(context, AppMotion.celebrate),
                            curve: AppMotion.pop,
                            builder: (context, scale, child) =>
                                Transform.scale(scale: scale, child: child),
                            child: _won
                                ? ToyBadge(
                                    color: colors.star,
                                    size: 120,
                                    child: const Icon(
                                      Icons.emoji_events_rounded,
                                      color: Colors.white,
                                      size: 72,
                                    ),
                                  )
                                : RobotAvatar(
                                    difficulty: match.difficulty,
                                    mood: RobotMood.happy,
                                    size: 120,
                                    semanticLabel: robotName,
                                  ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: scheme.onSurface,
                            fontWeight: FontWeight.w800,
                            height: 1.2,
                          ),
                        ),
                        Text(
                          subtitle,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xlg),
                        _FinalScore(match: match, won: _won),
                        const SizedBox(height: AppSpacing.xxlg),
                        _ResultButton(
                          icon: Icons.replay_rounded,
                          label: l10n.playAgain,
                          color: scheme.secondary,
                          onPressed: () => Navigator.of(context)
                              .pop(MatchResultAction.playAgain),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        _ResultButton(
                          icon: Icons.home_rounded,
                          label: l10n.home,
                          color: scheme.surface,
                          onPressed: () =>
                              Navigator.of(context).pop(MatchResultAction.home),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confetti,
                blastDirectionality: BlastDirectionality.explosive,
                numberOfParticles: 24,
                emissionFrequency: 0.08,
                gravity: 0.2,
                colors: [
                  colors.star,
                  colors.rock,
                  colors.paper,
                  colors.scissors,
                  colors.win,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FinalScore extends StatelessWidget {
  const _FinalScore({required this.match, required this.won});

  final Match match;
  final bool won;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final robotName = match.difficulty.robotName(context);
    final scoreStyle = theme.textTheme.headlineLarge?.copyWith(
      color: scheme.onSurface,
      fontWeight: FontWeight.w800,
      height: 1,
    );

    return Semantics(
      label: context.l10n.scoreSemantics(
        match.scoreboard.wins,
        robotName,
        match.scoreboard.losses,
      ),
      excludeSemantics: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: scheme.surface.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(color: Colors.white, width: 3),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const PlayerBadge(size: 48),
              Text(context.number(match.scoreboard.wins), style: scoreStyle),
              Text('-', style: scoreStyle),
              Text(context.number(match.scoreboard.losses), style: scoreStyle),
              RobotAvatar(
                difficulty: match.difficulty,
                mood: won ? RobotMood.sad : RobotMood.happy,
                size: 52,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultButton extends StatelessWidget {
  const _ResultButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ink = theme.colorScheme.onSurface;

    return ChunkyButton(
      color: color,
      onPressed: onPressed,
      semanticLabel: label,
      child: SizedBox(
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: ink),
            const SizedBox(width: AppSpacing.sm),
            Text(
              label,
              style: theme.textTheme.titleLarge?.copyWith(
                color: ink,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
