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

### Changed

- Dependencies are provided once from `RockPaperScissorsApp` and read from context.
- Home and game screens are split into smaller widget files.
- Stricter lint rules (`flutter_lints` 6 plus extra rules).

### Removed

- Unused `MatchModeX.label` and the legacy root `images/` folder.

## [3.0.0]

### Added

- Face-off game screen with the "Rock… Paper… Scissors!" chant.
- Three robot opponents mapped to Easy / Normal / Hard AI.
- "3 stars" (first to 3) and Endless modes.
- Confetti, sound effects and haptic feedback.
- English and Persian (RTL) with a runtime language switch.
- Lifetime stats stored with `shared_preferences`.
