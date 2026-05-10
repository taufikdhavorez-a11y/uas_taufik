import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/clue_model.dart';
import '../models/level_model.dart';
import '../data/game_data.dart';
import '../providers/game_provider.dart';
import '../widgets/tts_grid.dart';
import '../widgets/qwerty_keyboard.dart';
import 'package:flutter_animate/flutter_animate.dart';

class GameScreen extends ConsumerWidget {
  final LevelData level;

  const GameScreen({super.key, required this.level});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameProvider(level));
    final notifier = ref.read(gameProvider(level).notifier);

    // Listen for level completion
    ref.listen(gameProvider(level), (previous, next) {
      if (next.isCompleted && !(previous?.isCompleted ?? false)) {
        _showCompletionDialog(context, ref);
      }
    });

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
      backgroundColor: const Color(0xFF0F172A),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F172A),
              Color(0xFF020617),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'LEVEL ${level.levelNumber}',
                            style: GoogleFonts.outfit(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2,
                            ),
                          ),
                          Text(
                            'TTS PINTAR',
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildHintButton(gameState.hintsRemaining, notifier),
                  ],
                ),
              ),
              
              // Grid Area
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      )
                    ],
                  ),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: TTSGrid(level: level),
                      ),
                    ),
                  ),
                ),
              ),

              // Clue Area
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF38BDF8).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.help_center_rounded, color: Color(0xFF38BDF8), size: 22),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        activeClueText,
                        style: GoogleFonts.outfit(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                      ),
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
      ),
    );
  }

  void _showCompletionDialog(BuildContext context, WidgetRef ref) {
    final nextLevel = GameData.getNextLevel(level);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A).withOpacity(0.9),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_circle_rounded, color: Colors.greenAccent, size: 60),
                ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
                const SizedBox(height: 24),
                Text(
                  'LUAR BIASA!',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Kamu telah menyelesaikan Level ${level.levelNumber}',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 32),
                if (nextLevel != null)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent,
                      foregroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.pop(context); // Close dialog
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => GameScreen(level: nextLevel)),
                      );
                    },
                    child: Text(
                      'LEVEL SELANJUTNYA',
                      style: GoogleFonts.outfit(fontWeight: FontWeight.bold, letterSpacing: 1),
                    ),
                  )
                else
                  Text(
                    'Semua level di tingkat ini telah selesai!',
                    style: GoogleFonts.outfit(color: Colors.orangeAccent, fontWeight: FontWeight.bold),
                  ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    Navigator.pop(context); // Back to selector
                  },
                  child: Text(
                    'KEMBALI KE MENU',
                    style: GoogleFonts.outfit(color: Colors.white54, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHintButton(int hints, GameNotifier notifier) {
    return InkWell(
      onTap: () => notifier.useHint(),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF59E0B).withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF59E0B).withOpacity(0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.lightbulb_rounded, color: Color(0xFFF59E0B), size: 18),
            const SizedBox(width: 8),
            Text(
              '$hints',
              style: GoogleFonts.outfit(
                color: const Color(0xFFF59E0B),
                fontWeight: FontWeight.w800,
                fontSize: 14,
              ),
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

