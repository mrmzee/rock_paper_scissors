/// A hand in rock-paper-scissors.
enum Move { rock, paper, scissors }

extension MoveX on Move {
  /// The move that beats this one.
  Move get beatenBy => switch (this) {
        Move.rock => Move.paper,
        Move.paper => Move.scissors,
        Move.scissors => Move.rock,
      };

  /// The move this one beats.
  Move get beats => switch (this) {
        Move.rock => Move.scissors,
        Move.paper => Move.rock,
        Move.scissors => Move.paper,
      };
}
