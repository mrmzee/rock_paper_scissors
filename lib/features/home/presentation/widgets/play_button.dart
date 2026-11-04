import 'package:flutter/material.dart';
import 'package:rock_paper_scissors/core/l10n/l10n.dart';
import 'package:rock_paper_scissors/core/theme/app_motion.dart';
import 'package:rock_paper_scissors/core/theme/app_spacing.dart';
import 'package:rock_paper_scissors/core/widgets/chunky_button.dart';

/// Gently pulsing "Play!" button.
class PlayButton extends StatefulWidget {
  const PlayButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  State<PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton>
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
