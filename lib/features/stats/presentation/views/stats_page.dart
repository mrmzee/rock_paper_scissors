import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rock_paper_scissors/core/l10n/l10n.dart';
import 'package:rock_paper_scissors/core/theme/app_spacing.dart';
import 'package:rock_paper_scissors/core/theme/game_colors.dart';
import 'package:rock_paper_scissors/core/widgets/app_background.dart';
import 'package:rock_paper_scissors/core/widgets/toy_surface.dart';
import 'package:rock_paper_scissors/features/game/domain/entities/player_stats.dart';
import 'package:rock_paper_scissors/features/game/domain/repositories/stats_repository.dart';
import 'package:rock_paper_scissors/features/stats/presentation/widgets/favorite_move_card.dart';
import 'package:rock_paper_scissors/features/stats/presentation/widgets/reset_stats_dialog.dart';
import 'package:rock_paper_scissors/features/stats/presentation/widgets/robot_win_rates.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  late Future<PlayerStats> _future = _load();

  Future<PlayerStats> _load() => context.read<StatsRepository>().load();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(context.l10n.myTrophies),
        actions: [
          FutureBuilder<PlayerStats>(
            future: _future,
            builder: (context, snapshot) {
              final stats = snapshot.data;
              if (stats == null || stats.isEmpty) {
                return const SizedBox.shrink();
              }
              return IconButton(
                key: const Key('reset_stats'),
                tooltip: context.l10n.resetStats,
                icon: const Icon(Icons.delete_sweep_rounded),
                onPressed: _reset,
              );
            },
          ),
        ],
      ),
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: kToolbarHeight),
            child: FutureBuilder<PlayerStats>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return _StatsError(onRetry: _reload);
                }
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      semanticsLabel: context.l10n.loading,
                    ),
                  );
                }

                final stats = snapshot.data!;
                if (stats.isEmpty) {
                  return const _EmptyStats();
                }
                final favorite = stats.favoriteMove;

                return Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 760),
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.lg,
                        AppSpacing.md,
                        AppSpacing.lg,
                        AppSpacing.xxlg,
                      ),
                      children: [
                        const _StatsTopper(),
                        const SizedBox(height: AppSpacing.lg),
                        _WinRateCard(stats: stats),
                        const SizedBox(height: AppSpacing.lg),
                        _StatsTiles(stats: stats),
                        if (favorite != null) ...[
                          const SizedBox(height: AppSpacing.lg),
                          FavoriteMoveCard(
                            move: favorite,
                            count: stats.movesPlayed[favorite] ?? 0,
                          ),
                        ],
                        const SizedBox(height: AppSpacing.lg),
                        RobotWinRates(stats: stats),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _reload() {
    setState(() {
      _future = _load();
    });
  }

  Future<void> _reset() async {
    final repository = context.read<StatsRepository>();
    if (!await confirmResetStats(context)) return;
    await repository.clear();
    if (mounted) _reload();
  }
}

class _StatsTopper extends StatelessWidget {
  const _StatsTopper();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Row(
      children: [
        ToyBadge(
          color: scheme.secondary,
          size: 66,
          child: Icon(
            Icons.emoji_events_rounded,
            color: scheme.onSecondary,
            size: 36,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            context.l10n.niceRun,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: scheme.onSurface,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.7,
            ),
          ),
        ),
        Icon(Icons.star_rounded, size: 34, color: scheme.tertiary),
      ],
    );
  }
}

class _WinRateCard extends StatelessWidget {
  const _WinRateCard({required this.stats});

  final PlayerStats stats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final colors = GameColors.of(context);
    final l10n = context.l10n;
    final percent = NumberFormat.percentPattern(
      Localizations.localeOf(context).toLanguageTag(),
    ).format(stats.winRate);

    return ToySurface(
      color: scheme.primary,
      padding: const EdgeInsets.all(AppSpacing.lg),
      borderRadius: BorderRadius.circular(AppRadius.xl),
      depth: 7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.winRate,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: scheme.onPrimary.withValues(alpha: 0.86),
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                    Text(
                      percent,
                      style: theme.textTheme.displayMedium?.copyWith(
                        color: scheme.onPrimary,
                        fontWeight: FontWeight.w900,
                        height: 1,
                        letterSpacing: -1.5,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      l10n.roundsSummary(stats.roundsWon, stats.roundsPlayed),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: scheme.onPrimary.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              ToyBadge(
                color: scheme.secondary,
                size: 64,
                child: Icon(
                  Icons.star_rounded,
                  color: scheme.onSecondary,
                  size: 38,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Semantics(
            label: l10n.roundsBreakdown(
              stats.roundsWon,
              stats.roundsDrawn,
              stats.roundsLost,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: SizedBox(
                height: 14,
                child: stats.roundsPlayed == 0
                    ? ColoredBox(
                        color: scheme.onPrimary.withValues(alpha: 0.2),
                      )
                    : Row(
                        children: [
                          if (stats.roundsWon > 0)
                            Expanded(
                              flex: stats.roundsWon,
                              child: ColoredBox(color: colors.win),
                            ),
                          if (stats.roundsDrawn > 0)
                            Expanded(
                              flex: stats.roundsDrawn,
                              child: ColoredBox(color: colors.draw),
                            ),
                          if (stats.roundsLost > 0)
                            Expanded(
                              flex: stats.roundsLost,
                              child: ColoredBox(color: colors.loss),
                            ),
                        ],
                      ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              _BarLabel(
                icon: Icons.check_rounded,
                value: stats.roundsWon,
                color: colors.win,
              ),
              _BarLabel(
                icon: Icons.drag_handle_rounded,
                value: stats.roundsDrawn,
                color: colors.draw,
              ),
              _BarLabel(
                icon: Icons.close_rounded,
                value: stats.roundsLost,
                color: colors.loss,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BarLabel extends StatelessWidget {
  const _BarLabel({
    required this.icon,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          ToyBadge(
            color: color,
            size: 24,
            child: Icon(icon, color: Colors.white, size: 15),
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            context.number(value),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.w900,
                ),
          ),
        ],
      ),
    );
  }
}

class _StatsTiles extends StatelessWidget {
  const _StatsTiles({required this.stats});

  final PlayerStats stats;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = context.l10n;
    final tiles = [
      _StatToy(
        value: context.number(stats.matchesPlayed),
        label: l10n.matches,
        color: scheme.tertiary,
        ink: scheme.onTertiary,
        badgeColor: scheme.secondary,
        badgeInk: scheme.onSecondary,
        icon: Icons.emoji_events_rounded,
      ),
      _StatToy(
        value: context.number(stats.roundsPlayed),
        label: l10n.rounds,
        color: scheme.secondary,
        ink: scheme.onSecondary,
        badgeColor: scheme.primary,
        badgeInk: scheme.onPrimary,
        icon: Icons.replay_rounded,
      ),
      _StatToy(
        value: context.number(stats.bestStreak),
        label: l10n.bestStreak,
        color: const Color(0xFF54CFA0),
        ink: const Color(0xFF123C32),
        badgeColor: scheme.tertiary,
        badgeInk: scheme.onTertiary,
        icon: Icons.bolt_rounded,
      ),
      _StatToy(
        value: context.number(stats.currentStreak),
        label: l10n.currentStreak,
        color: scheme.primaryContainer,
        ink: scheme.onPrimaryContainer,
        badgeColor: scheme.secondary,
        badgeInk: scheme.onSecondary,
        icon: Icons.local_fire_department_rounded,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final perRow = constraints.maxWidth >= 560 ? tiles.length : 2;
        return Column(
          children: [
            for (var start = 0; start < tiles.length; start += perRow) ...[
              if (start > 0) const SizedBox(height: AppSpacing.md),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var index = start;
                      index < start + perRow && index < tiles.length;
                      index++) ...[
                    if (index > start) const SizedBox(width: AppSpacing.sm),
                    Expanded(child: tiles[index]),
                  ],
                ],
              ),
            ],
          ],
        );
      },
    );
  }
}

class _StatToy extends StatelessWidget {
  const _StatToy({
    required this.value,
    required this.label,
    required this.color,
    required this.ink,
    required this.badgeColor,
    required this.badgeInk,
    required this.icon,
  });

  final String value;
  final String label;
  final Color color;
  final Color ink;
  final Color badgeColor;
  final Color badgeInk;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ToySurface(
      color: color,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.md,
      ),
      borderRadius: BorderRadius.circular(AppRadius.lg),
      depth: 5,
      child: Column(
        children: [
          ToyBadge(
            color: badgeColor,
            size: 46,
            child: Icon(icon, color: badgeInk, size: 26),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: ink,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall?.copyWith(
              color: ink.withValues(alpha: 0.88),
              fontWeight: FontWeight.w900,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsError extends StatelessWidget {
  const _StatsError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ToyBadge(
            color: scheme.tertiary,
            size: 76,
            child: Icon(
              Icons.cloud_off_rounded,
              color: scheme.onTertiary,
              size: 38,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: Text(context.l10n.tryAgain),
          ),
        ],
      ),
    );
  }
}

class _EmptyStats extends StatelessWidget {
  const _EmptyStats();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xlg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ToyBadge(
                  color: scheme.secondary,
                  size: 68,
                  child: Icon(
                    Icons.back_hand_rounded,
                    color: scheme.onSecondary,
                    size: 38,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                ToyBadge(
                  color: scheme.tertiary,
                  size: 68,
                  child: Icon(
                    Icons.emoji_events_rounded,
                    color: scheme.onTertiary,
                    size: 38,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              context.l10n.noStatsYet,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: scheme.onSurface,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: AppSpacing.xlg),
            FilledButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.play_arrow_rounded),
              label: Text(context.l10n.play),
            ),
          ],
        ),
      ),
    );
  }
}
