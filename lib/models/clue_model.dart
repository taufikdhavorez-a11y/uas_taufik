enum ClueDirection { horizontal, vertical }

class Clue {
  final String id;
  final String text;
  final String answer;
  final int x;
  final int y;
  final ClueDirection direction;

  Clue({
    required this.id,
    required this.text,
    required this.answer,
    required this.x,
    required this.y,
    required this.direction,
  });

  int get length => answer.length;
}
