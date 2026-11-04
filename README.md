# Rock Paper Scissors

A kid-friendly Flutter Rock Paper Scissors game with a robot opponent, English and Persian (RTL) support, sound effects, and local stats.

## Features

- Face-off game screen: the robot on one side, the player on the other, big hand buttons in the thumb zone
- "Rock… Paper… Scissors!" chant with shaking hands before every reveal
- Three robot opponents (Robo Jr., Robo, Grumpy Robo) mapped to Easy / Normal / Hard AI, with reacting faces
- **3 stars** (first to 3) and **Endless** modes
- Confetti, sound effects (mutable) and haptic feedback
- English and Persian with runtime language switch; choices are remembered
- Lifetime stats stored with `shared_preferences`
- Respects the system "reduce motion" setting
- Clean architecture: domain / data / presentation + Bloc

## Getting started

```bash
flutter pub get
flutter test
flutter run
```

## Architecture

```text
lib/
  app.dart / main.dart
  l10n/            # ARB files + generated AppLocalizations
  core/
    audio/         # SoundService (audioplayers) + Sfx
    settings/      # language, sound, last mode/robot (SettingsCubit)
    theme/         # colors, motion, theme
    widgets/       # ChunkyButton, ToySurface, AppBackground
  features/
    home/          # mode + robot selection
    game/          # match engine, AI, game UI, result page
    stats/         # lifetime statistics
assets/
  fonts/           # Baloo Bhaijaan 2 (OFL)
  images/hands/    # Noto Emoji hand artwork (Apache 2.0)
  sounds/          # generated sound effects
```

## Credits

- Font: [Baloo Bhaijaan 2](https://fonts.google.com/specimen/Baloo+Bhaijaan+2), SIL Open Font License (`assets/fonts/OFL.txt`)
- Hand artwork: [Noto Emoji](https://github.com/googlefonts/noto-emoji), Apache License 2.0 (`assets/images/hands/LICENSE`)
