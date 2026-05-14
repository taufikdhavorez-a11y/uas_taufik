// Solver for Sulit Level 10 with Adjacency Check
void main() {
  const gridSize = 12;

  final words = [
    {'id': 'w1', 'answer': 'URBANISASI'},
    {'id': 'w2', 'answer': 'URBANISME'},
    {'id': 'w3', 'answer': 'REMIGRAN'},
    {'id': 'w4', 'answer': 'RASIAL'},
    {'id': 'w5', 'answer': 'MIGRASI'},
    {'id': 'w6', 'answer': 'MITIGASI'},
    {'id': 'w7', 'answer': 'SENTRA'},
    {'id': 'w8', 'answer': 'PLURALISME'},
  ];

  // We want to find a valid grid for these 8 words.
  // Since 8 words is too many to brute-force all at once, we'll try to find
  // an overlapping structure. Let's fix URBANISASI and URBANISME at (1,1).
  
  // Wait, let's just do a recursive backtracking solver.
  
  List<Map<String, dynamic>> bestSolution = [];
  int maxPlaced = 0;
  
  bool solve(int wordIndex, List<Map<String, dynamic>> placed) {
    if (wordIndex == words.length) {
      if (checkConnectivity(placed) && checkAdjacency(placed, gridSize)) {
        bestSolution = List.from(placed);
        return true;
      }
      return false;
    }
    
    if (placed.length > maxPlaced) {
      maxPlaced = placed.length;
      print('Placed $maxPlaced words...');
    }

    final wordToPlace = words[wordIndex];
    final answer = wordToPlace['answer'] as String;
    final id = wordToPlace['id'] as String;
    
    // For the first word, just place it at some specific spots to reduce symmetry.
    if (placed.isEmpty) {
      for (int x = 1; x <= gridSize - answer.length + 1; x += 2) {
        for (int y = 1; y <= gridSize; y += 2) {
          final p = {'id': id, 'answer': answer, 'x': x, 'y': y, 'dir': 'H'};
          placed.add(p);
          if (solve(wordIndex + 1, placed)) return true;
          placed.removeLast();
        }
      }
      return false;
    }

    // Try to intersect with already placed words
    // Find all possible valid intersections
    final possiblePlacements = <Map<String, dynamic>>[];
    
    for (int i = 0; i < answer.length; i++) {
      final letter = answer[i];
      for (final p in placed) {
        final pAnswer = p['answer'] as String;
        final px = p['x'] as int;
        final py = p['y'] as int;
        final pDir = p['dir'] as String;
        
        for (int j = 0; j < pAnswer.length; j++) {
          if (pAnswer[j] == letter) {
            // Found a matching letter!
            // If p is H, we must be V
            if (pDir == 'H') {
              final newX = px + j;
              final newY = py - i;
              if (newY >= 1 && newY + answer.length - 1 <= gridSize) {
                possiblePlacements.add({'id': id, 'answer': answer, 'x': newX, 'y': newY, 'dir': 'V'});
              }
            } else {
              // p is V, we must be H
              final newX = px - i;
              final newY = py + j;
              if (newX >= 1 && newX + answer.length - 1 <= gridSize) {
                possiblePlacements.add({'id': id, 'answer': answer, 'x': newX, 'y': newY, 'dir': 'H'});
              }
            }
          }
        }
      }
    }
    
    // Sort or shuffle possible placements if needed, but we'll just try them
    for (final placement in possiblePlacements) {
      placed.add(placement);
      if (isValidPartial(placed, gridSize)) {
        if (solve(wordIndex + 1, placed)) return true;
      }
      placed.removeLast();
    }

    // It's also possible a word doesn't intersect directly with the PREVIOUS words but connects later.
    // To simplify, we enforce that each newly placed word MUST intersect with at least one already placed word.
    // This naturally ensures connectivity and speeds up search immensely.
    return false;
  }
  
  print('Starting solver...');
  solve(0, []);
  
  if (bestSolution.isNotEmpty) {
    print('Found a valid solution!');
    printGrid(bestSolution, gridSize);
    for (final w in bestSolution) {
      print('Clue(id: "${w["id"]}", text: "", answer: "${w["answer"]}", x: ${w["x"]}, y: ${w["y"]}, direction: ClueDirection.${w["dir"] == "H" ? "horizontal" : "vertical"}),');
    }
  } else {
    print('No solution found.');
  }
}

bool isValidPartial(List<Map<String, dynamic>> words, int gridSize) {
  // Check bounds and clashes
  final cells = <String, String>{};
  for (final w in words) {
    final answer = w['answer'] as String;
    final x = w['x'] as int;
    final y = w['y'] as int;
    final dir = w['dir'] as String;
    for (int i = 0; i < answer.length; i++) {
      final cx = dir == 'H' ? x + i : x;
      final cy = dir == 'V' ? y + i : y;
      if (cx < 1 || cx > gridSize || cy < 1 || cy > gridSize) return false;
      final key = '$cx,$cy';
      if (cells.containsKey(key) && cells[key] != answer[i]) return false;
      cells[key] = answer[i];
    }
  }
  
  // Check adjacency for partial grid
  return checkAdjacency(words, gridSize);
}

bool checkConnectivity(List<Map<String, dynamic>> words) {
  if (words.isEmpty) return true;
  final Map<String, Set<String>> cellToIds = {};
  for (final w in words) {
    final answer = w['answer'] as String;
    final x = w['x'] as int;
    final y = w['y'] as int;
    final dir = w['dir'] as String;
    for (int i = 0; i < answer.length; i++) {
      final cx = dir == 'H' ? x + i : x;
      final cy = dir == 'V' ? y + i : y;
      final key = '$cx,$cy';
      cellToIds.putIfAbsent(key, () => {});
      cellToIds[key]!.add(w['id'] as String);
    }
  }
  final Set<String> connected = {words[0]['id'] as String};
  bool changed = true;
  while (changed) {
    changed = false;
    for (final entry in cellToIds.entries) {
      if (entry.value.length > 1 && entry.value.any((id) => connected.contains(id))) {
        for (final id in entry.value) {
          if (connected.add(id)) changed = true;
        }
      }
    }
  }
  return connected.length == words.length;
}

bool checkAdjacency(List<Map<String, dynamic>> words, int gridSize) {
  final cellDirs = <String, Set<String>>{};
  final cells = <String, String>{};
  
  for (final w in words) {
    final answer = w['answer'] as String;
    final x = w['x'] as int;
    final y = w['y'] as int;
    final dir = w['dir'] as String;
    for (int i = 0; i < answer.length; i++) {
      final cx = dir == 'H' ? x + i : x;
      final cy = dir == 'V' ? y + i : y;
      final key = '$cx,$cy';
      cells[key] = answer[i];
      cellDirs.putIfAbsent(key, () => {});
      cellDirs[key]!.add(dir);
    }
  }
  
  for (int y = 1; y <= gridSize; y++) {
    for (int x = 1; x <= gridSize; x++) {
      final key = '$x,$y';
      if (!cells.containsKey(key)) continue;
      
      final dirs = cellDirs[key]!;
      
      // Check horizontal neighbors (x+1)
      final rightKey = '${x+1},$y';
      if (cells.containsKey(rightKey)) {
        if (!dirs.contains('H') || !cellDirs[rightKey]!.contains('H')) {
          // If neither cell is part of a horizontal word, they are adjacent vertically side-by-side
          // Actually, if BOTH are part of a horizontal word, it's valid (it's the same horizontal word)
          // Wait, if they are adjacent, there MUST be a horizontal word covering them.
          return false;
        }
      }
      
      // Check vertical neighbors (y+1)
      final downKey = '$x,${y+1}';
      if (cells.containsKey(downKey)) {
        if (!dirs.contains('V') || !cellDirs[downKey]!.contains('V')) {
          return false;
        }
      }
      
      // Diagonal adjacency is valid in standard crosswords, but some strict rules might forbid it.
      // Assuming diagonal adjacency is allowed if no edges touch improperly.
    }
  }
  return true;
}

void printGrid(List<Map<String, dynamic>> words, int gridSize) {
  final cells = <String, String>{};
  for (final w in words) {
    final answer = w['answer'] as String;
    final x = w['x'] as int;
    final y = w['y'] as int;
    final dir = w['dir'] as String;
    for (int i = 0; i < answer.length; i++) {
      final cx = dir == 'H' ? x + i : x;
      final cy = dir == 'V' ? y + i : y;
      cells['$cx,$cy'] = answer[i];
    }
  }
  for (int y = 1; y <= gridSize; y++) {
    final row = StringBuffer('${y.toString().padLeft(2)} ');
    for (int x = 1; x <= gridSize; x++) {
      row.write(cells.containsKey('$x,$y') ? ' ${cells['$x,$y']} ' : ' . ');
    }
    print(row);
  }
}
