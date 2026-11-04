/// Spacing scale based on a 16dp unit.
abstract final class AppSpacing {
  static const double spaceUnit = 16;

  static const double xxs = 0.25 * spaceUnit;
  static const double xs = 0.375 * spaceUnit;
  static const double sm = 0.5 * spaceUnit;
  static const double md = 0.75 * spaceUnit;
  static const double lg = spaceUnit;
  static const double xlg = 1.5 * spaceUnit;
  static const double xxlg = 2 * spaceUnit;
  static const double xxxlg = 3 * spaceUnit;
}

/// Corner radii shared by surfaces and controls.
abstract final class AppRadius {
  static const double sm = 12;
  static const double md = 18;
  static const double lg = 24;
  static const double xl = 30;
}

/// Window-width breakpoint for side-by-side layouts.
abstract final class AppBreakpoints {
  static const double expanded = 720;
}
