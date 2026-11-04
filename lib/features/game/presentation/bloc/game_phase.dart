/// Where the current round is in the on-screen flow.
enum GamePhase {
  picking,

  /// Pass-and-play only: Player 1 has picked and hands the device over.
  handoff,
  revealing,
  roundResult,
  matchOver,
}
