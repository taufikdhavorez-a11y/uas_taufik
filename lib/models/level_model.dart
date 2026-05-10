import 'package:flutter/foundation.dart';
import 'clue_model.dart';

enum Difficulty { mudah, menengah, sulit }

class LevelData {
  final int levelNumber;
  final Difficulty difficulty;
  final List<Clue> clues;
  final int gridSize;

  LevelData({
    required this.levelNumber,
    required this.difficulty,
    required this.clues,
    this.gridSize = 7,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LevelData &&
          runtimeType == other.runtimeType &&
          levelNumber == other.levelNumber &&
          difficulty == other.difficulty &&
          gridSize == other.gridSize &&
          listEquals(clues, other.clues);

  @override
  int get hashCode =>
      levelNumber.hashCode ^
      difficulty.hashCode ^
      gridSize.hashCode ^
      clues.fold(0, (prev, element) => prev ^ element.hashCode);
}
