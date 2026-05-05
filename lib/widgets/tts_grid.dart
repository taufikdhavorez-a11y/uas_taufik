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

            return _buildCell(context, ref, x, y, gameState);
          },
        ),
      );
    });
  }

  Widget _buildCell(BuildContext context, WidgetRef ref, int x, int y, GameState state) {
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

    return GestureDetector(
      onTap: () => ref.read(gameProvider(level).notifier).setFocus(x, y),
      child: Container(
        decoration: BoxDecoration(
          color: isFocused 
              ? const Color(0xFF6E6E6E) // Focused cell color
              : (isPartOfActiveClue ? const Color(0xFF4A4A4A) : Colors.white),
          border: Border.all(color: Colors.black12, width: 0.5),
        ),
        child: Center(
          child: Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: (isPartOfActiveClue || isFocused) ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  bool _isCellInClue(Clue clue, int x, int y) {
    if (clue.direction == ClueDirection.horizontal) {
      return y == clue.y && x >= clue.x && x < clue.x + clue.answer.length;
    } else {
      return x == clue.x && y >= clue.y && y < clue.y + clue.answer.length;
    }
  }
}

