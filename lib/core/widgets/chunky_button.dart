import 'package:flutter/material.dart';
import 'package:rock_paper_scissors/core/theme/app_motion.dart';
import 'package:rock_paper_scissors/core/theme/app_spacing.dart';

/// A raised toy-like button that physically sinks into its base when pressed.
class ChunkyButton extends StatefulWidget {
  const ChunkyButton({
    super.key,
    required this.color,
    required this.child,
    required this.onPressed,
    this.borderRadius = const BorderRadius.all(Radius.circular(AppRadius.lg)),
    this.depth = 6,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppSpacing.lg,
      vertical: AppSpacing.md,
    ),
    this.selected = false,
    this.semanticLabel,
    this.tooltip,
  });

  final Color color;
  final Widget child;
  final VoidCallback? onPressed;
  final BorderRadius borderRadius;
  final double depth;
  final EdgeInsetsGeometry padding;

  /// Draws a highlight ring, used for the chosen option in a group.
  final bool selected;
  final String? semanticLabel;
  final String? tooltip;

  @override
  State<ChunkyButton> createState() => _ChunkyButtonState();
}

class _ChunkyButtonState extends State<ChunkyButton> {
  bool _pressed = false;
  bool _focused = false;

  bool get _enabled => widget.onPressed != null;

  void _setPressed(bool value) {
    if (!_enabled || _pressed == value) return;
    setState(() => _pressed = value);
  }

  void _activate() {
    if (!_enabled) return;
    widget.onPressed!();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final muted = !_enabled && !widget.selected;
    final base = muted
        ? Color.lerp(widget.color, scheme.surfaceContainerHighest, 0.6)!
        : widget.color;
    final edge = Color.lerp(base, Colors.black, 0.22)!;
    final sink = _pressed ? widget.depth * 0.8 : 0.0;
    final ringColor = _focused ? scheme.primary : Colors.white;
    final ringWidth = widget.selected || _focused ? 4.0 : 2.5;

    Widget button = AnimatedContainer(
      duration: AppMotion.of(context, AppMotion.press),
      curve: Curves.easeOut,
      margin: EdgeInsets.only(bottom: widget.depth),
      transform: Matrix4.translationValues(0, sink, 0),
      padding: widget.padding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color.lerp(base, Colors.white, 0.45)!, base],
        ),
        borderRadius: widget.borderRadius,
        border: Border.all(
          color: ringColor.withValues(alpha: widget.selected ? 1 : 0.85),
          width: ringWidth,
        ),
        boxShadow: [
          BoxShadow(
            color: edge,
            offset: Offset(0, widget.depth - sink),
            blurRadius: 0,
          ),
          if (_enabled)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              offset: Offset(0, widget.depth - sink + 4),
              blurRadius: 10,
            ),
          if (widget.selected)
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.9),
              blurRadius: 0,
              spreadRadius: 3,
            ),
        ],
      ),
      child: widget.child,
    );

    button = Semantics(
      button: true,
      enabled: _enabled,
      selected: widget.selected,
      label: widget.semanticLabel,
      onTap: _enabled ? _activate : null,
      excludeSemantics: widget.semanticLabel != null,
      child: FocusableActionDetector(
        enabled: _enabled,
        mouseCursor:
            _enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
        onShowFocusHighlight: (value) => setState(() => _focused = value),
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              _activate();
              return null;
            },
          ),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          excludeFromSemantics: true,
          onTapDown: (_) => _setPressed(true),
          onTapUp: (_) => _setPressed(false),
          onTapCancel: () => _setPressed(false),
          onTap: _activate,
          child: button,
        ),
      ),
    );

    if (widget.tooltip != null) {
      button = Tooltip(message: widget.tooltip, child: button);
    }
    return button;
  }
}

/// Round icon-only [ChunkyButton] with a 48dp touch target.
class ChunkyIconButton extends StatelessWidget {
  const ChunkyIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.color,
    this.iconColor,
    this.size = 48,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? iconColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ChunkyButton(
      color: color ?? scheme.surface,
      onPressed: onPressed,
      tooltip: tooltip,
      semanticLabel: tooltip,
      depth: 4,
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(size / 2.4),
      child: SizedBox.square(
        dimension: size,
        child: Icon(icon, size: size * 0.5, color: iconColor ?? scheme.primary),
      ),
    );
  }
}
