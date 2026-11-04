/// Opponent intelligence level.
enum Difficulty { easy, normal, hard }

extension DifficultyX on Difficulty {
  String get label => switch (this) {
        Difficulty.easy => 'Easy',
        Difficulty.normal => 'Normal',
        Difficulty.hard => 'Hard',
      };
}
