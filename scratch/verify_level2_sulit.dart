
void main() {
  final grid = <String, String>{};

  void addWord(String word, int x, int y, bool horizontal) {
    for (int i = 0; i < word.length; i++) {
      final cx = horizontal ? x + i : x;
      final cy = horizontal ? y : y + i;
      final key = "$cx,$cy";
      final char = word[i];
      if (grid.containsKey(key) && grid[key] != char) {
        throw Exception("Collision at $key: ${grid[key]} vs $char");
      }
      grid[key] = char;
    }
  }

  try {
    addWord("PROFESOR", 1, 1, true);
    addWord("PEDAGOGIK", 1, 1, false);
    addWord("OPERASI", 3, 1, false);
    addWord("ASASI", 3, 5, true);
    addWord("GURU", 8, 1, false);
    addWord("UTAMA", 8, 2, true);
    addWord("KOTA", 12, -1, false); // needs shift
    print("Base grid valid!");
  } catch (e) {
    print(e);
  }
}
