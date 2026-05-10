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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Clue &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          text == other.text &&
          answer == other.answer &&
          x == other.x &&
          y == other.y &&
          direction == other.direction;

  @override
  int get hashCode =>
      id.hashCode ^
      text.hashCode ^
      answer.hashCode ^
      x.hashCode ^
      y.hashCode ^
      direction.hashCode;

  int get length => answer.length;
}
