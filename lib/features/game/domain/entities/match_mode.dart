/// How a match ends.
enum MatchMode {
  /// First player to win [winsNeeded] rounds wins the match.
  bestOf5,

  /// Play until the player resets or leaves.
  endless,
}

extension MatchModeX on MatchMode {
  int? get winsNeeded => switch (this) {
        MatchMode.bestOf5 => 3,
        MatchMode.endless => null,
      };

  String get label => switch (this) {
        MatchMode.bestOf5 => 'Best of 5',
        MatchMode.endless => 'Endless',
      };
}
