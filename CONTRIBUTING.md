# Contributing

Thanks for helping improve Rock Paper Scissors!

## Setup

1. Install Flutter (stable). CI uses the version pinned in
   [`.github/workflows/ci.yml`](.github/workflows/ci.yml).
2. Clone the repo and fetch dependencies:

   ```bash
   flutter pub get
   ```

## Branches

- `main` is always releasable and protected: changes land through pull requests
  with a green CI.
- Create a branch per change:
  - `feat/<short-name>` for features
  - `fix/<short-name>` for bug fixes
  - `chore/<short-name>`, `docs/<short-name>`, `test/<short-name>`, `refactor/<short-name>`

## Commits

Use [Conventional Commits](https://www.conventionalcommits.org/):

```text
feat: add two-player mode
fix(stats): keep best streak after reset
```

Keep the subject under ~50 characters; explain the "why" in the body when it
is not obvious.

## Before opening a pull request

```bash
dart format lib test
flutter gen-l10n
flutter analyze
flutter test
```

CI runs the same checks and fails if formatting or the generated
localization files are out of date.

## Code guidelines

- Follow the existing layering: `domain` (pure Dart rules and entities),
  `data` (repositories and strategies), `presentation` (Bloc, views, widgets).
- Game rules belong in the domain layer, not in widgets or blocs.
- Dependencies are provided in [`lib/app.dart`](lib/app.dart); read them with
  `context.read<T>()` instead of passing them through constructors.
- Every user-facing string goes in both `lib/l10n/app_en.arb` and
  `lib/l10n/app_fa.arb`. Check layouts in Persian (RTL) too.
- Respect reduced motion (`AppMotion.reduced`) for new animations.
- Add or update tests for every behavior change.
