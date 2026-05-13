import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/clue_model.dart';
import '../models/level_model.dart';
import '../providers/game_provider.dart';


class TTSGrid extends ConsumerWidget {
  final LevelData level;

  const TTSGrid({super.key, required this.level});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameProvider(level));
    final size = level.gridSize;

    return LayoutBuilder(builder: (context, constraints) {
      final double totalPadding = 8.0; // 4.0 * 2
      final double totalSpacing = (size - 1) * 2.0;
      final double cellSize = (constraints.maxWidth - totalPadding - totalSpacing) / size;

      return Container(
        width: constraints.maxWidth,
        height: constraints.maxWidth,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFF2C2C2C), // Dark grey grid background
          borderRadius: BorderRadius.circular(4),
        ),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: size,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
          ),
          itemCount: size * size,
          itemBuilder: (context, index) {
            final x = index % size;
            final y = index ~/ size;
            final isPlayable = gameState.solutionGrid[y][x].isNotEmpty;
            
            if (!isPlayable) return Container(color: const Color(0xFF2C2C2C));

            return _buildCell(context, ref, x, y, gameState, cellSize);
          },
        ),
      );
    });
  }

  Widget _buildCell(BuildContext context, WidgetRef ref, int x, int y, GameState state, double cellSize) {
    // Check if this cell is part of the active clue
    bool isPartOfActiveClue = false;
    if (state.focusedX != null && state.focusedY != null) {
      final activeClue = state.level.clues.firstWhere(
        (c) => c.direction == state.focusedDirection && 
               _isCellInClue(c, state.focusedX!, state.focusedY!),
        orElse: () => state.level.clues.firstWhere(
          (c) => _isCellInClue(c, state.focusedX!, state.focusedY!),
          orElse: () => Clue(id: '', text: '', answer: '', x: -1, y: -1, direction: ClueDirection.horizontal),
        ),
      );
      isPartOfActiveClue = _isCellInClue(activeClue, x, y);
    }

    final isFocused = state.focusedX == x && state.focusedY == y;
    final value = state.userGrid[y][x];
    final solution = state.solutionGrid[y][x];
    
    final bool isNotEmpty = value.isNotEmpty;
    final bool isCorrect = isNotEmpty && value == solution;
    final bool isWrong = isNotEmpty && value != solution;

    // Determine cell background color
    Color cellColor;
    if (isFocused) {
      cellColor = const Color(0xFF334155); // Muted Slate Focus
    } else if (isCorrect) {
      cellColor = const Color(0xFF065F46).withOpacity(0.6); // Deep Emerald
    } else if (isWrong) {
      cellColor = const Color(0xFF991B1B).withOpacity(0.6); // Deep Rose
    } else if (isPartOfActiveClue) {
      cellColor = const Color(0xFF1E293B); // Active word color
    } else {
      cellColor = Colors.white.withOpacity(0.9);
    }

    // Determine text color
    Color textColor;
    if (isFocused || isPartOfActiveClue || isCorrect || isWrong) {
      textColor = Colors.white;
    } else {
      textColor = const Color(0xFF0F172A); // Deep Navy text
    }

    return GestureDetector(
      onTap: () => ref.read(gameProvider(level).notifier).setFocus(x, y),
      child: Container(
        decoration: BoxDecoration(
          color: cellColor,
          border: Border.all(
            color: isFocused ? const Color(0xFF38BDF8) : Colors.black.withOpacity(0.1), 
            width: isFocused ? 2.5 : 0.5,
          ),
          borderRadius: BorderRadius.circular(cellSize * 0.2), // Proportional corner radius
        ),
        child: Center(
          child: FittedBox(
            fit: BoxFit.contain,
            child: Padding(
              padding: EdgeInsets.all(cellSize * 0.1),
              child: Text(
                value,
                style: GoogleFonts.outfit(
                  fontSize: cellSize * 0.6,
                  fontWeight: FontWeight.w800,
                  color: textColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _isCellInClue(Clue clue, int x, int y) {
    if (clue.direction == ClueDirection.horizontal) {
      return y == (clue.y - 1) && x >= (clue.x - 1) && x < (clue.x - 1) + clue.answer.length;
    } else {
      return x == (clue.x - 1) && y >= (clue.y - 1) && y < (clue.y - 1) + clue.answer.length;
    }
  }
}

