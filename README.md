# Rock Paper Scissors

[![CI](https://github.com/mrmzee/rock_paper_scissors/actions/workflows/ci.yml/badge.svg)](https://github.com/mrmzee/rock_paper_scissors/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

A kid-friendly Flutter Rock Paper Scissors game with a robot opponent, English and Persian (RTL) support, sound effects, and local stats.

## Features

- Face-off game screen: the robot on one side, the player on the other, big hand buttons in the thumb zone
- "Rock… Paper… Scissors!" chant with shaking hands before every reveal
- Three robot opponents (Robo Jr., Robo, Grumpy Robo) mapped to Easy / Normal / Hard AI, with reacting faces
- **3 stars** (first to 3) and **Endless** modes
- Confetti, sound effects (mutable) and haptic feedback
- English and Persian with runtime language switch; choices are remembered
- Light, dark or follow-device theme
- Lifetime stats (favorite hand, streaks, win rate per robot) stored with `shared_preferences`, with reset
- Respects the system "reduce motion" setting
- Clean architecture: domain / data / presentation + Bloc

## Getting started

Requires Flutter stable (CI pins the exact version in [`.github/workflows/ci.yml`](.github/workflows/ci.yml)).

```bash
flutter pub get
flutter run
```

## Development

```bash
dart format lib test     # format
flutter gen-l10n         # regenerate lib/l10n/app_localizations*.dart after editing ARB files
flutter analyze          # static analysis
flutter test             # unit + widget tests
flutter test --coverage  # writes coverage/lcov.info
```

### App icon and splash

The launcher icon and splash are rendered from the in-app robot and hand artwork (`tool/branding/app_icon_art.dart`):

```bash
flutter test tool/generate_icon_test.dart   # writes assets/branding/*.png
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

See [CONTRIBUTING.md](CONTRIBUTING.md) for branch naming, commit style and the pull request checklist.

## Android release signing

Release builds use debug keys unless `android/key.properties` exists.

1. Create an upload keystore (keep it out of git; `*.jks` is ignored):

   ```bash
   keytool -genkey -v -keystore android/upload-keystore.jks \
     -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```

2. Copy [`android/key.properties.example`](android/key.properties.example) to `android/key.properties` and fill in the passwords.
3. Build: `flutter build appbundle --release`.

## Architecture

```text
lib/
  app.dart         # root widget; provides repositories and use cases
  main.dart        # wires SharedPreferences-backed implementations
  l10n/            # ARB files + generated AppLocalizations
  core/
    audio/         # SoundService (audioplayers) + Sfx
    settings/      # language, sound, last mode/robot (SettingsCubit)
    theme/         # colors, motion, spacing, theme
    widgets/       # ChunkyButton, ToySurface, AppBackground
  features/
    home/          # mode + robot selection
    onboarding/    # first-launch "how to play" slides
    game/          # match engine, AI, game UI, result page
    stats/         # lifetime statistics
assets/
  fonts/           # Baloo Bhaijaan 2 (OFL)
  images/hands/    # Noto Emoji hand artwork (Apache 2.0)
  sounds/          # generated sound effects
```

Each feature follows `domain` (entities, repository interfaces, use cases) → `data` (implementations) → `presentation` (Bloc, views, widgets).

## Roadmap

- [x] Theme selection (system / light / dark)
- [x] Reset stats from the trophies page
- [x] Richer stats: favorite move, win rate per robot, current streak
- [x] First-launch "how to play" onboarding
- [ ] Two-player pass-and-play mode
- [ ] Achievements / badges
- [ ] Crash reporting

## License

[MIT](LICENSE). Bundled assets keep their own licenses (see Credits).

## Credits

- Font: [Baloo Bhaijaan 2](https://fonts.google.com/specimen/Baloo+Bhaijaan+2), SIL Open Font License (`assets/fonts/OFL.txt`)
- Hand artwork: [Noto Emoji](https://github.com/googlefonts/noto-emoji), Apache License 2.0 (`assets/images/hands/LICENSE`)
