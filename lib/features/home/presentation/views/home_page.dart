import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rock_paper_scissors/core/audio/sound_service.dart';
import 'package:rock_paper_scissors/core/l10n/l10n.dart';
import 'package:rock_paper_scissors/core/settings/app_settings.dart';
import 'package:rock_paper_scissors/core/settings/settings_cubit.dart';
import 'package:rock_paper_scissors/core/theme/app_motion.dart';
import 'package:rock_paper_scissors/core/theme/app_spacing.dart';
import 'package:rock_paper_scissors/core/theme/game_colors.dart';
import 'package:rock_paper_scissors/core/widgets/app_background.dart';
import 'package:rock_paper_scissors/core/widgets/chunky_button.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/difficulty.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/match_mode.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/move.dart';
import 'package:rock_paper_scissors/features/game/domain/repositories/stats_repository.dart';
import 'package:rock_paper_scissors/features/game/domain/usecases/play_round.dart';
import 'package:rock_paper_scissors/features/game/domain/usecases/record_match_stats.dart';
import 'package:rock_paper_scissors/features/game/presentation/mappers/robot_look.dart';
import 'package:rock_paper_scissors/features/game/presentation/views/game_page.dart';
import 'package:rock_paper_scissors/features/game/presentation/widgets/hand_art.dart';
import 'package:rock_paper_scissors/features/game/presentation/widgets/robot_avatar.dart';
import 'package:rock_paper_scissors/features/stats/presentation/views/stats_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.playRound,
    required this.recordMatchStats,
    required this.statsRepository,
  });

  final PlayRound playRound;
  final RecordMatchStats recordMatchStats;
  final StatsRepository statsRepository;

  void _openGame(BuildContext context, AppSettings settings) {
    context.playSfx(Sfx.tap);
    Navigator.of(context).push(
      _fadeRoute(
        context,
        GamePage(
          mode: settings.mode,
          difficulty: settings.difficulty,
          playRound: playRound,
          recordMatchStats: recordMatchStats,
        ),
      ),
    );
  }

  void _openStats(BuildContext context) {
    context.playSfx(Sfx.tap);
    Navigator.of(context).push(
      _fadeRoute(context, StatsPage(statsRepository: statsRepository)),
    );
  }

  Route<void> _fadeRoute(BuildContext context, Widget page) {
    if (AppMotion.reduced(context)) {
      return MaterialPageRoute<void>(builder: (_) => page);
    }

    return PageRouteBuilder<void>(
      transitionDuration: AppMotion.page,
      reverseTransitionDuration: AppMotion.page,
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: AppMotion.pageEnter,
        );
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.035),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<SettingsCubit>();

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: BlocBuilder<SettingsCubit, AppSettings>(
            builder: (context, settings) {
              final topBar = _HomeTopBar(
                soundOn: settings.soundOn,
                onLanguage: () => cubit.toggleLanguage(
                  Localizations.localeOf(context),
                ),
                onSound: cubit.toggleSound,
                onStats: () => _openStats(context),
              );
              final hero = FittedBox(
                fit: BoxFit.scaleDown,
                child: _Hero(difficulty: settings.difficulty),
              );
              final choices = Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _SectionTitle(
                    icon: Icons.sports_esports_rounded,
                    text: l10n.gameType,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (final mode in MatchMode.values) ...[
                          if (mode != MatchMode.values.first)
                            const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: _ModeCard(
                              mode: mode,
                              selected: settings.mode == mode,
                              onPressed: () {
                                context.playSfx(Sfx.tap);
                                cubit.selectMode(mode);
                              },
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _SectionTitle(
                    icon: Icons.smart_toy_rounded,
                    text: l10n.chooseRobot,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (final difficulty in Difficulty.values) ...[
                          if (difficulty != Difficulty.values.first)
                            const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: _RobotCard(
                              difficulty: difficulty,
                              selected: settings.difficulty == difficulty,
                              onPressed: () {
                                context.playSfx(Sfx.tap);
                                cubit.selectDifficulty(difficulty);
                              },
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _PlayButton(
                    onPressed: () => _openGame(context, settings),
                  ),
                ],
              );

              return LayoutBuilder(
                builder: (context, constraints) {
                  final wide = constraints.maxWidth > constraints.maxHeight &&
                      constraints.maxWidth >= 600;

                  return Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.sm,
                      AppSpacing.lg,
                      AppSpacing.md,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: wide ? 960 : 520),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            topBar,
                            const SizedBox(height: AppSpacing.sm),
                            Expanded(
                              child: wide
                                  ? Row(
                                      children: [
                                        Expanded(child: hero),
                                        const SizedBox(width: AppSpacing.lg),
                                        Expanded(
                                          child: _ScaleToFit(child: choices),
                                        ),
                                      ],
                                    )
                                  : LayoutBuilder(
                                      builder: (context, box) => Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Expanded(child: hero),
                                          const SizedBox(
                                            height: AppSpacing.sm,
                                          ),
                                          ConstrainedBox(
                                            constraints: BoxConstraints(
                                              maxHeight: box.maxHeight * 0.74,
                                            ),
                                            child: _ScaleToFit(child: choices),
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Keeps [child] at the full available width and scales it down uniformly
/// when it is taller than the space, so the home screen never scrolls.
class _ScaleToFit extends StatelessWidget {
  const _ScaleToFit({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Center(
        heightFactor: 1,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: SizedBox(width: constraints.maxWidth, child: child),
        ),
      ),
    );
  }
}

class _HomeTopBar extends StatelessWidget {
  const _HomeTopBar({
    required this.soundOn,
    required this.onLanguage,
    required this.onSound,
    required this.onStats,
  });

  final bool soundOn;
  final VoidCallback onLanguage;
  final VoidCallback onSound;
  final VoidCallback onStats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final colors = GameColors.of(context);
    final l10n = context.l10n;

    return Row(
      children: [
        ChunkyButton(
          key: const Key('language_toggle'),
          color: scheme.surface,
          onPressed: onLanguage,
          tooltip: l10n.switchLanguageTooltip,
          semanticLabel:
              '${l10n.switchLanguageTooltip}: ${l10n.switchLanguage}',
          depth: 4,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: SizedBox(
            height: 44,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.translate_rounded, color: scheme.primary, size: 22),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  l10n.switchLanguage,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: scheme.onSurface,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        ChunkyIconButton(
          icon: soundOn ? Icons.volume_up_rounded : Icons.volume_off_rounded,
          tooltip: soundOn ? l10n.soundOn : l10n.soundOff,
          onPressed: onSound,
        ),
        const Spacer(),
        ChunkyIconButton(
          icon: Icons.emoji_events_rounded,
          tooltip: l10n.myTrophies,
          color: colors.star,
          iconColor: Colors.white,
          onPressed: onStats,
        ),
      ],
    );
  }
}

class _Hero extends StatefulWidget {
  const _Hero({required this.difficulty});

  final Difficulty difficulty;

  @override
  State<_Hero> createState() => _HeroState();
}

class _HeroState extends State<_Hero> with SingleTickerProviderStateMixin {
  late final AnimationController _float = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (AppMotion.reduced(context)) {
      _float.stop();
    } else if (!_float.isAnimating) {
      _float.repeat();
    }
  }

  @override
  void dispose() {
    _float.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = context.l10n;

    Widget floatingHand(Move move, double phase, double angle) {
      return AnimatedBuilder(
        animation: _float,
        builder: (context, child) {
          final t = _float.value * math.pi * 2 + phase;
          return Transform.translate(
            offset: Offset(0, math.sin(t) * 6),
            child: Transform.rotate(angle: angle, child: child),
          );
        },
        child: HandArt(move: move, size: 52),
      );
    }

    return Column(
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: SizedBox(
            height: 124,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                floatingHand(Move.rock, 0, -0.25),
                const SizedBox(width: AppSpacing.sm),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    floatingHand(Move.paper, 2, 0),
                    const Spacer(),
                  ],
                ),
                const SizedBox(width: AppSpacing.sm),
                RobotAvatar(
                  difficulty: widget.difficulty,
                  size: 108,
                  semanticLabel: widget.difficulty.robotName(context),
                ),
                const SizedBox(width: AppSpacing.sm),
                floatingHand(Move.scissors, 4, 0.25),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          l10n.appTitle,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineMedium?.copyWith(
            color: scheme.onSurface,
            fontWeight: FontWeight.w800,
            height: 1.15,
          ),
        ),
        Text(
          l10n.homeGreeting,
          textAlign: TextAlign.center,
          style: theme.textTheme.titleMedium?.copyWith(
            color: scheme.onSurfaceVariant,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Row(
      children: [
        Icon(icon, color: scheme.primary, size: 22),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.titleMedium?.copyWith(
              color: scheme.onSurface,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.mode,
    required this.selected,
    required this.onPressed,
  });

  final MatchMode mode;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final colors = GameColors.of(context);
    final l10n = context.l10n;

    final (title, hint, accent) = switch (mode) {
      MatchMode.bestOf5 => (
          l10n.modeBestOf5,
          l10n.modeBestOf5Hint,
          colors.star
        ),
      MatchMode.endless => (
          l10n.modeEndless,
          l10n.modeEndlessHint,
          colors.paper
        ),
    };
    final Widget art = switch (mode) {
      MatchMode.bestOf5 => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < 3; i++)
              Icon(
                Icons.star_rounded,
                size: 26,
                color: selected ? Colors.white : colors.star,
              ),
          ],
        ),
      MatchMode.endless => Icon(
          Icons.all_inclusive_rounded,
          size: 30,
          color: selected ? Colors.white : colors.paper,
        ),
    };

    return ChunkyButton(
      key: Key('mode_${mode.name}'),
      color: selected ? accent : scheme.surface,
      selected: selected,
      onPressed: onPressed,
      semanticLabel: '$title. $hint',
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.sm,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 30, child: Center(child: art)),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              color: scheme.onSurface,
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
          ),
          Text(
            hint,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurface.withValues(alpha: 0.8),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _RobotCard extends StatelessWidget {
  const _RobotCard({
    required this.difficulty,
    required this.selected,
    required this.onPressed,
  });

  final Difficulty difficulty;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final name = difficulty.robotName(context);
    final hint = difficulty.robotHint(context);

    return ChunkyButton(
      key: Key('robot_${difficulty.name}'),
      color: selected
          ? Color.lerp(difficulty.robotColor, Colors.white, 0.45)!
          : scheme.surface,
      selected: selected,
      onPressed: onPressed,
      semanticLabel: '$name. $hint',
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.sm,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RobotAvatar(
            difficulty: difficulty,
            mood: selected ? RobotMood.happy : RobotMood.idle,
            size: 52,
          ),
          const SizedBox(height: AppSpacing.xxs),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              name,
              maxLines: 1,
              style: theme.textTheme.titleSmall?.copyWith(
                color: scheme.onSurface,
                fontWeight: FontWeight.w800,
                height: 1.1,
              ),
            ),
          ),
          Text(
            hint,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall?.copyWith(
              color: scheme.onSurface.withValues(alpha: 0.8),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlayButton extends StatefulWidget {
  const _PlayButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  State<_PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<_PlayButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: AppMotion.pulse,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (AppMotion.reduced(context)) {
      _pulse.stop();
    } else if (!_pulse.isAnimating) {
      _pulse.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final label = context.l10n.play;

    return ScaleTransition(
      scale: Tween<double>(begin: 1, end: 1.04).animate(
        CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
      ),
      child: ChunkyButton(
        key: const Key('play_button'),
        color: scheme.secondary,
        depth: 7,
        onPressed: widget.onPressed,
        semanticLabel: label,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.xs,
        ),
        child: SizedBox(
          height: 52,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.play_arrow_rounded,
                size: 40,
                color: scheme.onSecondary,
              ),
              const SizedBox(width: AppSpacing.xs),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
                    style: theme.textTheme.headlineSmall?.copyWith(
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
    );
  }
}
