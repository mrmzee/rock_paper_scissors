# Changelog

All notable changes to this project are documented here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and the project uses
[Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added

- GitHub Actions CI (format, generated localizations, analyze, test with coverage).
- Dependabot, issue and pull request templates, contributing guide and MIT license.
- Release signing for Android from `android/key.properties`.
- Tests for settings, preference-backed repositories, the robot strategy and home navigation.
- App icon and splash screen generated from the in-app robot artwork.
- Localized app name on Android and iOS ("سنگ کاغذ قیچی" in Persian).
- Theme button on the home screen: follow device, light or dark (remembered).
- Richer trophies page: favorite hand, current streak and win rate against each robot.
- Reset stats from the trophies page (with confirmation).
- First-launch "how to play" slides, reopened from the home "?" button.
- Eight badges (first win, streaks, perfect match, beating Grumpy Robo, and more), announced mid-match and on the result page, collected on the trophies page.

### Changed

- Stats are stored as one versioned JSON document; totals from older versions are migrated automatically.
- Best streak now counts round wins across matches.
- Dependencies are provided once from `RockPaperScissorsApp` and read from context.
- Home and game screens are split into smaller widget files.
- Stricter lint rules (`flutter_lints` 6 plus extra rules).
- `flutter_bloc` 9, `equatable` 3 and other dependency upgrades.
- Android toolchain: Gradle 9.3.1, AGP 9.1.0, Kotlin 2.4.0.

### Removed

- Unused `MatchModeX.label` and the legacy root `images/` folder.

### Fixed

- Readable button labels on yellow and blue buttons in dark mode.
- The trophies page "Try again" button did not reload.

## [3.0.0]

### Added

- Face-off game screen with the "Rock… Paper… Scissors!" chant.
- Three robot opponents mapped to Easy / Normal / Hard AI.
- "3 stars" (first to 3) and Endless modes.
- Confetti, sound effects and haptic feedback.
- English and Persian (RTL) with a runtime language switch.
- Lifetime stats stored with `shared_preferences`.
