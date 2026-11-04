import 'package:flutter/material.dart';
import 'package:rock_paper_scissors/core/l10n/l10n.dart';

/// Asks before erasing stats; resolves to `true` only on an explicit yes.
Future<bool> confirmResetStats(BuildContext context) async {
  final l10n = context.l10n;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) {
      final scheme = Theme.of(context).colorScheme;
      return AlertDialog(
        icon: Icon(Icons.delete_sweep_rounded, color: scheme.tertiary),
        title: Text(l10n.resetStatsTitle),
        content: Text(l10n.resetStatsBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            key: const Key('confirm_reset_stats'),
            style: TextButton.styleFrom(foregroundColor: scheme.error),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.reset),
          ),
        ],
      );
    },
  );
  return confirmed ?? false;
}
