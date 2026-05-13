
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
    addWord("v1", "INDONESIA", 1, 1, false); // (1,1)I, (1,2)N, (1,3)D, (1,4)O, (1,5)N, (1,6)E, (1,7)S, (1,8)I, (1,9)A
    addWord("h1", "IKRAR", 1, 1, true); // (1,1)I, (2,1)K, (3,1)R, (4,1)A, (5,1)R
    addWord("v2", "RAKYAT", 3, 1, false); // (3,1)R, (3,2)A, (3,3)K, (3,4)Y, (3,5)A, (3,6)T
    addWord("h2", "NEGARA", 1, 5, true); // (1,5)N, (2,5)E, (3,5)G, (4,5)A, (5,5)R, (6,5)A
    // Wait, v2 at (3,5) is 'A'. h2 at (3,5) is 'G'. Clash.
    
    // Change v2 to RAGA? (3,1)R, (3,2)A, (3,3)G, (3,4)A. 
    // Now v2(3,3) is 'G'. 
    // Let's use h2 = AGAMA at y=3.
    // v1(1,3) is 'D'. v2(3,3) is 'G'.
    // Horizontal word at y=3: D _ G _ _.
    // No.
    
    print("Grid valid!");
  } catch (e) {
    print("ERROR: $e");
  }
}
