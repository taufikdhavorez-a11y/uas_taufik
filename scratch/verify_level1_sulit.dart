
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
    addWord("PROKLAMASI", 1, 1, true);
    addWord("PAHLAWAN", 1, 1, false);
    // Intersection at (1,1) 'P'.
    
    addWord("HASIL", 3, 1, false);
    // Intersection at (3,1) 'O' vs 'H'. Collision.
    
    print("Grid valid!");
  } catch (e) {
    print(e);
  }
}
