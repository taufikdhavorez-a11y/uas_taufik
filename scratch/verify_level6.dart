import 'package:flutter/foundation.dart';


enum ClueDirection { horizontal, vertical }

class Clue {
  final String id;
  final String answer;
  final int x;
  final int y;
  final ClueDirection direction;

  Clue(this.id, this.answer, this.x, this.y, this.direction);
}

void main() {
  List<Clue> clues = [
    Clue('h1', 'ASTRONOMI', 1, 1, ClueDirection.horizontal),
    Clue('v1', 'ASTRONOM', 1, 1, ClueDirection.vertical),
    Clue('h2', 'STUDI', 1, 3, ClueDirection.horizontal),
    Clue('v2', 'ROTASI', 5, 1, ClueDirection.vertical),
    Clue('h3', 'OBSERVASI', 1, 5, ClueDirection.horizontal),
    Clue('v3', 'SATELIT', 3, 3, ClueDirection.vertical),
    Clue('h4', 'ATMOSFER', 3, 7, ClueDirection.horizontal),
    Clue('v4', 'GALAKSI', 7, 1, ClueDirection.vertical),
    Clue('h5', 'GRAVITASI', 4, 9, ClueDirection.horizontal),
    Clue('v5', 'BINTANG', 9, 1, ClueDirection.vertical),
    Clue('h6', 'PLANET', 7, 5, ClueDirection.horizontal),
  ];

  Map<String, String> grid = {};

  for (var clue in clues) {
    for (int i = 0; i < clue.answer.length; i++) {
      int cx = clue.direction == ClueDirection.horizontal ? clue.x + i : clue.x;
      int cy = clue.direction == ClueDirection.vertical ? clue.y + i : clue.y;
      String key = '$cx,$cy';
      String char = clue.answer[i];

      if (grid.containsKey(key) && grid[key] != char) {
        debugPrint('BENTROK at ($cx, $cy): ${grid[key]} vs $char (Word: ${clue.id})');
      }
      grid[key] = char;
    }
  }

  debugPrint('Grid verification complete.');
}
