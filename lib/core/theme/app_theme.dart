import 'package:flutter/material.dart';
import 'package:rock_paper_scissors/core/theme/app_colors.dart';
import 'package:rock_paper_scissors/core/theme/app_spacing.dart';
import 'package:rock_paper_scissors/core/theme/game_colors.dart';

abstract final class AppTheme {
  static const fontFamily = 'BalooBhaijaan2';

  static ThemeData get light => _build(Brightness.light, GameColors.light);

  static ThemeData get dark => _build(Brightness.dark, GameColors.dark);

  static ThemeData _build(Brightness brightness, GameColors gameColors) {
    final dark = brightness == Brightness.dark;
    final generated = ColorScheme.fromSeed(
      seedColor: AppColors.seed,
      brightness: brightness,
    );
    final scheme = dark
        ? generated.copyWith(
            primary: const Color(0xFF83C3FF),
            onPrimary: const Color(0xFF10233A),
            primaryContainer: const Color(0xFF254B75),
            onPrimaryContainer: const Color(0xFFD8EBFF),
            secondary: AppColors.yellow,
            onSecondary: const Color(0xFF443300),
            tertiary: AppColors.coral,
            onTertiary: const Color(0xFF45131A),
            surface: const Color(0xFF2D3853),
            onSurface: const Color(0xFFF5F8FF),
            onSurfaceVariant: const Color(0xFFD0DAEE),
            surfaceContainerLowest: const Color(0xFF1E2943),
            surfaceContainerLow: const Color(0xFF2D3853),
            surfaceContainer: const Color(0xFF35415E),
            surfaceContainerHigh: const Color(0xFF414E6D),
            surfaceContainerHighest: const Color(0xFF4D5B7A),
            outline: const Color(0xFFB2C0DA),
            outlineVariant: const Color(0xFF61708F),
          )
        : generated.copyWith(
            primary: AppColors.blue,
            onPrimary: Colors.white,
            primaryContainer: const Color(0xFFD8ECFF),
            onPrimaryContainer: const Color(0xFF102B4A),
            secondary: AppColors.orange,
            onSecondary: const Color(0xFF402000),
            tertiary: AppColors.coral,
            onTertiary: const Color(0xFF4A111A),
            surface: AppColors.card,
            onSurface: AppColors.ink,
            onSurfaceVariant: AppColors.mutedInk,
            surfaceContainerLowest: Colors.white,
            surfaceContainerLow: const Color(0xFFFCFEFF),
            surfaceContainer: const Color(0xFFE8F7FF),
            surfaceContainerHigh: const Color(0xFFD8F0FF),
            surfaceContainerHighest: const Color(0xFFC5E8FA),
            outline: const Color(0xFF657A95),
            outlineVariant: const Color(0xFFB6D4E5),
          );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      extensions: [gameColors],
      scaffoldBackgroundColor: gameColors.gradientBottom,
      fontFamily: fontFamily,
    );
    final textTheme = base.textTheme;
    final buttonRadius = BorderRadius.circular(AppRadius.lg);

    return base.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: textTheme.titleMedium?.copyWith(
          color: scheme.onSurface,
          fontWeight: FontWeight.w900,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(58),
          backgroundColor: scheme.secondary,
          foregroundColor: scheme.onSecondary,
          elevation: 5,
          shadowColor: scheme.secondary.withValues(alpha: 0.72),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xlg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: buttonRadius,
            side: BorderSide(
                color: Colors.white.withValues(alpha: 0.8), width: 2),
          ),
          textStyle: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 0.2,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(54),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xlg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(borderRadius: buttonRadius),
          side: BorderSide(color: scheme.outline, width: 1.6),
          textStyle: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(48, 48),
          textStyle: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: scheme.surface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: buttonRadius,
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surface,
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: buttonRadius),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          visualDensity: VisualDensity.standard,
          textStyle: WidgetStatePropertyAll(
            textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
          ),
          side: WidgetStatePropertyAll(
            BorderSide(color: scheme.outline, width: 1.4),
          ),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            return states.contains(WidgetState.selected)
                ? scheme.primary
                : scheme.surfaceContainer;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            return states.contains(WidgetState.selected)
                ? scheme.onPrimary
                : scheme.onSurface;
          }),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.tertiary,
        linearTrackColor: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
    );
  }
}
