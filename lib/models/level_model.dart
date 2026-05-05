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
    this.gridSize = 7, // Default 7x7 for all levels to ensure enough space
  });
}
