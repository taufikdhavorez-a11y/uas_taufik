import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/clue_model.dart';
import '../models/level_model.dart';

class GameState {
  final LevelData level;
  final List<List<String>> userGrid;
  final List<List<String>> solutionGrid;
  final int? focusedX;
  final int? focusedY;
  final ClueDirection focusedDirection;
  final bool isCompleted;
  final int hintsRemaining;
  final Set<String> answeredClueIds;

  GameState({
    required this.level,
    required this.userGrid,
    required this.solutionGrid,
    this.focusedX,
    this.focusedY,
    this.focusedDirection = ClueDirection.horizontal,
    this.isCompleted = false,
    this.hintsRemaining = 10,
    this.answeredClueIds = const {},
  });

  GameState copyWith({
    LevelData? level,
    List<List<String>>? userGrid,
    List<List<String>>? solutionGrid,
    int? focusedX,
    int? focusedY,
    ClueDirection? focusedDirection,
    bool? isCompleted,
    int? hintsRemaining,
    Set<String>? answeredClueIds,
  }) {
    return GameState(
      level: level ?? this.level,
      userGrid: userGrid ?? this.userGrid,
      solutionGrid: solutionGrid ?? this.solutionGrid,
      focusedX: focusedX ?? this.focusedX,
      focusedY: focusedY ?? this.focusedY,
      focusedDirection: focusedDirection ?? this.focusedDirection,
      isCompleted: isCompleted ?? this.isCompleted,
      hintsRemaining: hintsRemaining ?? this.hintsRemaining,
      answeredClueIds: answeredClueIds ?? this.answeredClueIds,
    );
  }
}

class GameNotifier extends StateNotifier<GameState> {
  GameNotifier(LevelData level) : super(_initialState(level));

  static GameState _initialState(LevelData level) {
    final size = level.gridSize;
    final userGrid = List.generate(size, (_) => List.generate(size, (_) => ''));
    final solutionGrid = List.generate(
      size,
      (_) => List.generate(size, (_) => ''),
    );

    for (var clue in level.clues) {
      for (int i = 0; i < clue.answer.length; i++) {
        int nx =
            (clue.x - 1) + (clue.direction == ClueDirection.horizontal ? i : 0);
        int ny =
            (clue.y - 1) + (clue.direction == ClueDirection.vertical ? i : 0);
        solutionGrid[ny][nx] = clue.answer[i];
      }
    }

    return GameState(
      level: level,
      userGrid: userGrid,
      solutionGrid: solutionGrid,
    );
  }

  void updateCell(int x, int y, String value) {
    if (state.solutionGrid[y][x].isEmpty) return; // Not a playable cell

    final newUserGrid = [
      ...state.userGrid.map((row) => [...row]),
    ];
    newUserGrid[y][x] = value.toUpperCase();

    state = state.copyWith(userGrid: newUserGrid);
    _checkCompletion();

    if (value.isNotEmpty) {
      _moveFocus(x, y, true);
    }
  }

  void deleteCell() {
    if (state.focusedX == null || state.focusedY == null) return;

    final x = state.focusedX!;
    final y = state.focusedY!;

    final newUserGrid = [
      ...state.userGrid.map((row) => [...row]),
    ];

    if (newUserGrid[y][x].isEmpty) {
      // Move focus back first if current cell is already empty
      _moveFocus(x, y, false);
      final nx = state.focusedX!;
      final ny = state.focusedY!;
      newUserGrid[ny][nx] = '';
    } else {
      newUserGrid[y][x] = '';
    }

    state = state.copyWith(userGrid: newUserGrid);
    _checkCompletion();
  }

  void setFocus(int x, int y) {
    if (state.solutionGrid[y][x].isEmpty) return;

    ClueDirection newDir = state.focusedDirection;

    // Determine if the clicked cell is part of the currently active clue
    bool clickedSameWord = false;
    if (state.focusedX != null && state.focusedY != null) {
      try {
        final currentActiveClue = state.level.clues.firstWhere(
          (c) =>
              c.direction == state.focusedDirection &&
              ((c.direction == ClueDirection.horizontal &&
                      state.focusedY == (c.y - 1) &&
                      state.focusedX! >= (c.x - 1) &&
                      state.focusedX! < (c.x - 1) + c.answer.length) ||
                  (c.direction == ClueDirection.vertical &&
                      state.focusedX == (c.x - 1) &&
                      state.focusedY! >= (c.y - 1) &&
                      state.focusedY! < (c.y - 1) + c.answer.length)),
        );

        if (currentActiveClue.direction == ClueDirection.horizontal) {
          clickedSameWord =
              (y == currentActiveClue.y &&
              x >= currentActiveClue.x &&
              x < currentActiveClue.x + currentActiveClue.answer.length);
        } else {
          clickedSameWord =
              (x == currentActiveClue.x &&
              y >= currentActiveClue.y &&
              y < currentActiveClue.y + currentActiveClue.answer.length);
        }
      } catch (e) {
        // No active clue found matching
      }
    }

    // Find all clues containing the clicked cell
    final containingClues = state.level.clues.where((c) {
      if (c.direction == ClueDirection.horizontal) {
        return y == (c.y - 1) &&
            x >= (c.x - 1) &&
            x < (c.x - 1) + c.answer.length;
      } else {
        return x == (c.x - 1) &&
            y >= (c.y - 1) &&
            y < (c.y - 1) + c.answer.length;
      }
    }).toList();

    if (containingClues.isEmpty) return;

    Clue? targetClue;

    if (clickedSameWord && containingClues.length > 1) {
      // Toggle direction if clicking an intersection within the same word
      newDir = state.focusedDirection == ClueDirection.horizontal
          ? ClueDirection.vertical
          : ClueDirection.horizontal;
      targetClue = containingClues.firstWhere(
        (c) => c.direction == newDir,
        orElse: () => containingClues.first,
      );
      newDir = targetClue.direction;
    } else {
      // Try to keep the current direction
      targetClue = containingClues.firstWhere(
        (c) => c.direction == newDir,
        orElse: () => containingClues.first,
      );
      newDir = targetClue.direction;
    }

    // Set focus to the specific box clicked
    state = state.copyWith(focusedX: x, focusedY: y, focusedDirection: newDir);
  }

  void useHint() {
    if (state.hintsRemaining <= 0) return;
    if (state.focusedX == null || state.focusedY == null) return;

    final x = state.focusedX!;
    final y = state.focusedY!;

    // If already correct, don't waste hint
    if (state.userGrid[y][x] == state.solutionGrid[y][x]) return;

    final newUserGrid = [
      ...state.userGrid.map((row) => [...row]),
    ];
    newUserGrid[y][x] = state.solutionGrid[y][x];

    state = state.copyWith(
      userGrid: newUserGrid,
      hintsRemaining: state.hintsRemaining - 1,
    );

    _checkCompletion();
    _moveFocus(x, y, true);
  }

  void _moveFocus(int x, int y, bool forward) {
    int dx = state.focusedDirection == ClueDirection.horizontal
        ? (forward ? 1 : -1)
        : 0;
    int dy = state.focusedDirection == ClueDirection.vertical
        ? (forward ? 1 : -1)
        : 0;

    int nx = x + dx;
    int ny = y + dy;

    if (nx >= 0 &&
        nx < state.level.gridSize &&
        ny >= 0 &&
        ny < state.level.gridSize) {
      if (state.solutionGrid[ny][nx].isNotEmpty) {
        state = state.copyWith(focusedX: nx, focusedY: ny);
      }
    }
  }

  void _checkCompletion() {
    bool complete = true;
    for (int y = 0; y < state.level.gridSize; y++) {
      for (int x = 0; x < state.level.gridSize; x++) {
        if (state.solutionGrid[y][x].isNotEmpty &&
            state.userGrid[y][x] != state.solutionGrid[y][x]) {
          complete = false;
          break;
        }
      }
      if (!complete) break;
    }
    state = state.copyWith(isCompleted: complete);
    _checkClueCompletion();
  }

  void _checkClueCompletion() {
    final newlyAnswered = <String>{};
    int extraHints = 0;

    for (var clue in state.level.clues) {
      if (state.answeredClueIds.contains(clue.id)) continue;

      bool clueComplete = true;
      for (int i = 0; i < clue.answer.length; i++) {
        int nx =
            (clue.x - 1) + (clue.direction == ClueDirection.horizontal ? i : 0);
        int ny =
            (clue.y - 1) + (clue.direction == ClueDirection.vertical ? i : 0);

        if (state.userGrid[ny][nx] != state.solutionGrid[ny][nx]) {
          clueComplete = false;
          break;
        }
      }

      if (clueComplete) {
        newlyAnswered.add(clue.id);
        extraHints++;
      }
    }

    if (newlyAnswered.isNotEmpty) {
      state = state.copyWith(
        answeredClueIds: {...state.answeredClueIds, ...newlyAnswered},
        hintsRemaining: state.hintsRemaining + extraHints,
      );

      // Auto-move focus to the next incomplete clue
      if (!state.isCompleted) {
        _moveToNextIncompleteClue();
      }
    }
  }

  void _moveToNextIncompleteClue() {
    Clue? nextClue;

    // Find the first clue that is not yet completed
    for (var clue in state.level.clues) {
      bool isClueComplete = true;
      for (int i = 0; i < clue.answer.length; i++) {
        int nx = (clue.x - 1) + (clue.direction == ClueDirection.horizontal ? i : 0);
        int ny = (clue.y - 1) + (clue.direction == ClueDirection.vertical ? i : 0);
        if (state.userGrid[ny][nx] != state.solutionGrid[ny][nx]) {
          isClueComplete = false;
          break;
        }
      }

      if (!isClueComplete) {
        nextClue = clue;
        break;
      }
    }

    if (nextClue != null) {
      // Find the first empty cell in this clue to focus on
      int fx = nextClue.x - 1;
      int fy = nextClue.y - 1;

      for (int i = 0; i < nextClue.answer.length; i++) {
        int nx = (nextClue.x - 1) + (nextClue.direction == ClueDirection.horizontal ? i : 0);
        int ny = (nextClue.y - 1) + (nextClue.direction == ClueDirection.vertical ? i : 0);
        if (state.userGrid[ny][nx].isEmpty) {
          fx = nx;
          fy = ny;
          break;
        }
      }

      state = state.copyWith(
        focusedX: fx,
        focusedY: fy,
        focusedDirection: nextClue.direction,
      );
    }
  }
}

final gameProvider =
    StateNotifierProvider.family<GameNotifier, GameState, LevelData>((
      ref,
      level,
    ) {
      return GameNotifier(level);
    });
