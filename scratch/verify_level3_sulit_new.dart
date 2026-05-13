
void main() {
  final grid = <String, String>{};

  void addWord(String id, String word, int x, int y, bool horizontal) {
    for (int i = 0; i < word.length; i++) {
      final cx = horizontal ? x + i : x;
      final cy = horizontal ? y : y + i;
      final key = "$cx,$cy";
      final char = word[i];
      if (grid.containsKey(key) && grid[key] != char) {
        throw Exception("Collision at $key for word $id ($word): ${grid[key]} vs $char");
      }
      grid[key] = char;
    }
  }

  try {
    addWord("h1", "REFORMASI", 1, 1, true);
    addWord("v1", "REVOLUSI", 1, 1, false);
    addWord("h2", "VISUAL", 1, 3, true);
    addWord("v2", "FASET", 3, 1, false);
    addWord("v3", "MALU", 6, 1, false);
    addWord("h3", "TIM", 3, 5, true);
    addWord("h5", "UTAMA", 1, 6, true);
    addWord("v4", "MARI", 5, 5, false);
    addWord("h4", "SABAR", 1, 7, true);
    
    print("Grid valid! No clashes.");
    
    // Print grid for visual check
    for (int y = 1; y <= 8; y++) {
      String line = "";
      for (int x = 1; x <= 9; x++) {
        line += grid["$x,$y"] ?? ".";
        line += " ";
      }
      print(line);
    }
    
  } catch (e) {
    print("ERROR: $e");
  }
}
