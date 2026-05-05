import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/clue_model.dart';
import '../models/level_model.dart';
import '../providers/game_provider.dart';
import '../widgets/tts_grid.dart';
import '../widgets/qwerty_keyboard.dart';

class GameScreen extends ConsumerWidget {
  final LevelData level;

  const GameScreen({super.key, required this.level});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameProvider(level));
    final notifier = ref.read(gameProvider(level).notifier);

    // Find active clue text
    String activeClueText = "Pilih kotak untuk melihat pertanyaan";
    if (gameState.focusedX != null && gameState.focusedY != null) {
      final activeClue = level.clues.firstWhere(
        (c) => c.direction == gameState.focusedDirection && 
               _isCellInClue(c, gameState.focusedX!, gameState.focusedY!),
        orElse: () => level.clues.firstWhere(
          (c) => _isCellInClue(c, gameState.focusedX!, gameState.focusedY!),
          orElse: () => Clue(id: '', text: '...', answer: '', x: 0, y: 0, direction: ClueDirection.horizontal),
        ),
      );
      activeClueText = activeClue.text;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFA6E5A), // Coral background
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => notifier.useHint(),
                        icon: const Icon(Icons.lightbulb_outline, color: Colors.white, size: 20),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${gameState.hintsRemaining}',
                        style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Text(
                    'TTS Pintar Umum #${level.levelNumber}',
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.help_outline, color: Colors.white, size: 22),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            
            // Grid Area
            Expanded(
              child: Container(
                color: const Color(0xFF212121), // Dark grid container background
                child: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TTSGrid(level: level),
                    ),
                  ),
                ),
              ),
            ),

            // Clue Area
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: const Color(0xFFFA6E5A),
              child: Row(
                children: [
                  const Icon(Icons.group_outlined, color: Colors.white70, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      activeClueText,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    onPressed: () => notifier.useHint(),
                    icon: const Icon(Icons.lightbulb_outline, color: Colors.white70, size: 24),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),

            // QWERTY Keyboard
            QwertyKeyboard(
              onKeyTap: (key) {
                if (gameState.focusedX != null && gameState.focusedY != null) {
                  notifier.updateCell(gameState.focusedX!, gameState.focusedY!, key);
                }
              },
              onDeleteTap: () {
                notifier.deleteCell();
              },
            ),
          ],
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

