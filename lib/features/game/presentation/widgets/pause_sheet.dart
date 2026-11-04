import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rock_paper_scissors/core/l10n/l10n.dart';
import 'package:rock_paper_scissors/core/settings/app_settings.dart';
import 'package:rock_paper_scissors/core/settings/settings_cubit.dart';
import 'package:rock_paper_scissors/core/theme/app_spacing.dart';
import 'package:rock_paper_scissors/core/widgets/chunky_button.dart';

enum PauseAction { resume, restart, home }

/// Keeps restart and leave out of reach of accidental taps during play.
Future<PauseAction?> showPauseSheet(BuildContext context) {
  return showModalBottomSheet<PauseAction>(
    context: context,
    isScrollControlled: true,
    builder: (_) => const _PauseSheet(),
  );
}

class _PauseSheet extends StatelessWidget {
  const _PauseSheet();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xlg,
          0,
          AppSpacing.xlg,
          AppSpacing.xlg,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _SheetButton(
                  icon: Icons.play_arrow_rounded,
                  label: l10n.resume,
                  color: scheme.secondary,
                  onPressed: () =>
                      Navigator.of(context).pop(PauseAction.resume),
                ),
                const SizedBox(height: AppSpacing.md),
                _SheetButton(
                  icon: Icons.replay_rounded,
                  label: l10n.restart,
                  color: scheme.primaryContainer,
                  onPressed: () =>
                      Navigator.of(context).pop(PauseAction.restart),
                ),
                const SizedBox(height: AppSpacing.md),
                BlocBuilder<SettingsCubit, AppSettings>(
                  buildWhen: (previous, current) =>
                      previous.soundOn != current.soundOn,
                  builder: (context, settings) => _SheetButton(
                    icon: settings.soundOn
                        ? Icons.volume_up_rounded
                        : Icons.volume_off_rounded,
                    label: settings.soundOn ? l10n.soundOn : l10n.soundOff,
                    color: scheme.surfaceContainer,
                    onPressed: context.read<SettingsCubit>().toggleSound,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                _SheetButton(
                  icon: Icons.home_rounded,
                  label: l10n.home,
                  color: scheme.surface,
                  onPressed: () => Navigator.of(context).pop(PauseAction.home),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SheetButton extends StatelessWidget {
  const _SheetButton({
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
        height: 44,
        child: Row(
          children: [
            Icon(icon, size: 32, color: ink),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: ink,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
