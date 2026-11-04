import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rock_paper_scissors/core/settings/settings_cubit.dart';

/// Short sound effects bundled under `assets/sounds/`.
enum Sfx {
  tap('tap'),
  tick('tick'),
  reveal('reveal'),
  win('win'),
  lose('lose'),
  draw('draw'),
  matchWin('match_win'),
  matchLose('match_lose');

  const Sfx(this.fileName);

  final String fileName;
}

abstract interface class SoundService {
  void play(Sfx sfx);

  void dispose();
}

/// Used in tests and anywhere audio should stay quiet.
final class SilentSoundService implements SoundService {
  const SilentSoundService();

  @override
  void play(Sfx sfx) {}

  @override
  void dispose() {}
}

/// Plays effects with one reusable player per effect so rapid taps restart
/// the sound instead of stacking players.
final class AudioSoundService implements SoundService {
  final Map<Sfx, AudioPlayer> _players = {};

  @override
  void play(Sfx sfx) {
    _play(sfx).catchError((Object error) {
      debugPrint('Sound ${sfx.name} failed: $error');
    });
  }

  Future<void> _play(Sfx sfx) async {
    final player = _players.putIfAbsent(sfx, () {
      return AudioPlayer()..setReleaseMode(ReleaseMode.stop);
    });
    await player.stop();
    await player.play(AssetSource('sounds/${sfx.fileName}.wav'));
  }

  @override
  void dispose() {
    for (final player in _players.values) {
      player.dispose();
    }
    _players.clear();
  }
}

extension SfxContext on BuildContext {
  /// Plays [sfx] unless the player muted sounds in settings.
  void playSfx(Sfx sfx) {
    if (!read<SettingsCubit>().state.soundOn) return;
    read<SoundService>().play(sfx);
  }
}
