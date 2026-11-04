import 'package:flutter/material.dart';
import 'package:rock_paper_scissors/core/l10n/l10n.dart';
import 'package:rock_paper_scissors/core/theme/app_spacing.dart';
import 'package:rock_paper_scissors/core/theme/game_colors.dart';
import 'package:rock_paper_scissors/core/widgets/chunky_button.dart';

/// Language, sound and trophies buttons above the home screen.
class HomeTopBar extends StatelessWidget {
  const HomeTopBar({
    super.key,
    required this.soundOn,
    required this.onLanguage,
    required this.onSound,
    required this.themeMode,
    required this.onTheme,
    required this.onStats,
  });

  final bool soundOn;
  final VoidCallback onLanguage;
  final VoidCallback onSound;
  final ThemeMode themeMode;
  final VoidCallback onTheme;
  final VoidCallback onStats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final colors = GameColors.of(context);
    final l10n = context.l10n;

    return Row(
      children: [
        Flexible(
          flex: 8,
          child: ChunkyButton(
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
                  Icon(Icons.translate_rounded,
                      color: scheme.primary, size: 22),
                  const SizedBox(width: AppSpacing.xs),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        l10n.switchLanguage,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: scheme.onSurface,
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
        const SizedBox(width: AppSpacing.sm),
        ChunkyIconButton(
          icon: soundOn ? Icons.volume_up_rounded : Icons.volume_off_rounded,
          tooltip: soundOn ? l10n.soundOn : l10n.soundOff,
          onPressed: onSound,
        ),
        const SizedBox(width: AppSpacing.sm),
        ChunkyIconButton(
          key: const Key('theme_toggle'),
          icon: switch (themeMode) {
            ThemeMode.system => Icons.brightness_auto_rounded,
            ThemeMode.light => Icons.light_mode_rounded,
            ThemeMode.dark => Icons.dark_mode_rounded,
          },
          tooltip: switch (themeMode) {
            ThemeMode.system => l10n.themeSystem,
            ThemeMode.light => l10n.themeLight,
            ThemeMode.dark => l10n.themeDark,
          },
          onPressed: onTheme,
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
