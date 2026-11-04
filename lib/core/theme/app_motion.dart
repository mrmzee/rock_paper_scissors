import 'package:flutter/material.dart';

/// Material 3 motion tokens used across the app.
abstract final class AppMotion {
  static const Duration press = Durations.short1;
  static const Duration quick = Durations.short4;
  static const Duration standard = Durations.medium2;
  static const Duration page = Durations.medium4;
  static const Duration pulse = Durations.long2;
  static const Duration celebrate = Duration(milliseconds: 900);

  static const Curve standardCurve = Easing.standard;
  static const Curve pageEnter = Easing.emphasizedDecelerate;
  static const Curve pop = Curves.elasticOut;

  static Duration of(BuildContext context, [Duration duration = standard]) {
    if (MediaQuery.disableAnimationsOf(context)) return Duration.zero;
    return duration;
  }

  static bool reduced(BuildContext context) =>
      MediaQuery.disableAnimationsOf(context);
}
