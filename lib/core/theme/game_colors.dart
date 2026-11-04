import 'package:flutter/material.dart';
import 'package:rock_paper_scissors/core/theme/app_colors.dart';

/// Game colors that sit outside [ColorScheme]: outcomes, hands, backdrop.
@immutable
final class GameColors extends ThemeExtension<GameColors> {
  const GameColors({
    required this.win,
    required this.loss,
    required this.draw,
    required this.gradientTop,
    required this.gradientBottom,
    required this.rock,
    required this.paper,
    required this.scissors,
    required this.star,
    required this.handInk,
  });

  final Color win;
  final Color loss;
  final Color draw;
  final Color gradientTop;
  final Color gradientBottom;
  final Color rock;
  final Color paper;
  final Color scissors;
  final Color star;

  /// Text and icon color drawn on top of the hand colors.
  final Color handInk;

  static const light = GameColors(
    win: AppColors.winLight,
    loss: AppColors.lossLight,
    draw: AppColors.drawLight,
    gradientTop: AppColors.gradientTopLight,
    gradientBottom: AppColors.gradientBottomLight,
    rock: AppColors.rock,
    paper: AppColors.paperHand,
    scissors: AppColors.scissors,
    star: AppColors.star,
    handInk: AppColors.ink,
  );

  static const dark = GameColors(
    win: AppColors.winDark,
    loss: AppColors.lossDark,
    draw: AppColors.drawDark,
    gradientTop: AppColors.gradientTopDark,
    gradientBottom: AppColors.gradientBottomDark,
    rock: AppColors.rock,
    paper: AppColors.paperHand,
    scissors: AppColors.scissors,
    star: AppColors.star,
    handInk: AppColors.ink,
  );

  static GameColors of(BuildContext context) {
    final colors = Theme.of(context).extension<GameColors>();
    assert(colors != null, 'GameColors is missing from ThemeData.extensions');
    return colors!;
  }

  @override
  GameColors copyWith({
    Color? win,
    Color? loss,
    Color? draw,
    Color? gradientTop,
    Color? gradientBottom,
    Color? rock,
    Color? paper,
    Color? scissors,
    Color? star,
    Color? handInk,
  }) {
    return GameColors(
      win: win ?? this.win,
      loss: loss ?? this.loss,
      draw: draw ?? this.draw,
      gradientTop: gradientTop ?? this.gradientTop,
      gradientBottom: gradientBottom ?? this.gradientBottom,
      rock: rock ?? this.rock,
      paper: paper ?? this.paper,
      scissors: scissors ?? this.scissors,
      star: star ?? this.star,
      handInk: handInk ?? this.handInk,
    );
  }

  @override
  GameColors lerp(ThemeExtension<GameColors>? other, double t) {
    if (other is! GameColors) return this;
    return GameColors(
      win: Color.lerp(win, other.win, t)!,
      loss: Color.lerp(loss, other.loss, t)!,
      draw: Color.lerp(draw, other.draw, t)!,
      gradientTop: Color.lerp(gradientTop, other.gradientTop, t)!,
      gradientBottom: Color.lerp(gradientBottom, other.gradientBottom, t)!,
      rock: Color.lerp(rock, other.rock, t)!,
      paper: Color.lerp(paper, other.paper, t)!,
      scissors: Color.lerp(scissors, other.scissors, t)!,
      star: Color.lerp(star, other.star, t)!,
      handInk: Color.lerp(handInk, other.handInk, t)!,
    );
  }
}
