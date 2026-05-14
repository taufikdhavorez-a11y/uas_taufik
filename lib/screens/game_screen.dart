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
                  margin: EdgeInsets.symmetric(
                    horizontal: level.difficulty == Difficulty.mudah ? 20 : 12, 
                    vertical: 10
                  ),
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
                        padding: EdgeInsets.all(level.difficulty == Difficulty.mudah ? 20.0 : 8.0),
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

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.85),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) {
        return _CompletionOverlay(level: level, nextLevel: nextLevel);
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(opacity: anim1, child: child);
      },
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
      return y == (clue.y - 1) && x >= (clue.x - 1) && x < (clue.x - 1) + clue.answer.length;
    } else {
      return x == (clue.x - 1) && y >= (clue.y - 1) && y < (clue.y - 1) + clue.answer.length;
    }
  }
}


// -- Premium Completion Overlay --

class _CompletionOverlay extends StatefulWidget {
  final LevelData level;
  final LevelData? nextLevel;

  const _CompletionOverlay({required this.level, required this.nextLevel});

  @override
  State<_CompletionOverlay> createState() => _CompletionOverlayState();
}

class _CompletionOverlayState extends State<_CompletionOverlay>
    with TickerProviderStateMixin {
  late final AnimationController _particleController;
  final List<_Particle> _particles = [];

  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    final colors = [
      const Color(0xFFFFD700),
      const Color(0xFF7CFC00),
      const Color(0xFF00BFFF),
      const Color(0xFFFF69B4),
      const Color(0xFFFF8C00),
      const Color(0xFFDA70D6),
    ];
    for (int i = 0; i < 30; i++) {
      _particles.add(_Particle(
        x: (i * 37 % 100) / 100.0,
        delay: (i * 0.1) % 2.5,
        color: colors[i % colors.length],
        size: 4.0 + (i % 5) * 2,
      ));
    }
  }

  @override
  void dispose() {
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _particleController,
            builder: (context, _) {
              return CustomPaint(
                size: size,
                painter: _ParticlePainter(
                  particles: _particles,
                  progress: _particleController.value,
                ),
              );
            },
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(colors: [
                        const Color(0xFFFFD700).withOpacity(0.3),
                        const Color(0xFFFFD700).withOpacity(0.05),
                      ]),
                      border: Border.all(
                          color: const Color(0xFFFFD700).withOpacity(0.5), width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFFD700).withOpacity(0.4),
                          blurRadius: 40,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.emoji_events_rounded,
                        color: Color(0xFFFFD700), size: 64),
                  )
                      .animate()
                      .scale(
                        begin: const Offset(0, 0),
                        end: const Offset(1, 1),
                        duration: 700.ms,
                        curve: Curves.elasticOut,
                      )
                      .then()
                      .shimmer(
                        duration: 1200.ms,
                        color: Colors.white.withOpacity(0.6),
                        delay: 200.ms,
                      ),
                  const SizedBox(height: 28),
                  Text(
                    'LUAR BIASA!',
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                      shadows: [
                        Shadow(
                          color: const Color(0xFFFFD700).withOpacity(0.8),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .slideY(begin: 0.5, end: 0, delay: 300.ms, duration: 500.ms, curve: Curves.easeOut)
                      .fadeIn(delay: 300.ms, duration: 500.ms),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Text(
                      'Level ${widget.level.levelNumber} berhasil diselesaikan!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 500.ms, duration: 400.ms)
                      .slideY(begin: 0.3, end: 0, delay: 500.ms, duration: 400.ms),
                  const SizedBox(height: 40),
                  if (widget.nextLevel != null)
                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFD700),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                          elevation: 0,
                        ),
                        icon: const Icon(Icons.play_arrow_rounded, size: 26),
                        label: Text(
                          'LEVEL SELANJUTNYA',
                          style: GoogleFonts.outfit(fontWeight: FontWeight.w900, letterSpacing: 1, fontSize: 16),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => GameScreen(level: widget.nextLevel!)),
                          );
                        },
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 700.ms, duration: 400.ms)
                        .slideY(begin: 0.4, end: 0, delay: 700.ms, duration: 400.ms)
                  else
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.orangeAccent.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.workspace_premium_rounded, color: Colors.orangeAccent, size: 24),
                          const SizedBox(width: 10),
                          Text('Semua level selesai!',
                              style: GoogleFonts.outfit(color: Colors.orangeAccent, fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                    ).animate().fadeIn(delay: 700.ms),
                  const SizedBox(height: 14),
                  TextButton.icon(
                    icon: const Icon(Icons.arrow_back_rounded, color: Colors.white38, size: 18),
                    label: Text('Kembali ke Menu',
                        style: GoogleFonts.outfit(color: Colors.white38, fontWeight: FontWeight.w600, fontSize: 15)),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  ).animate().fadeIn(delay: 900.ms, duration: 400.ms),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Particle {
  final double x;
  final double delay;
  final Color color;
  final double size;
  const _Particle({required this.x, required this.delay, required this.color, required this.size});
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;
  const _ParticlePainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < particles.length; i++) {
      final p = particles[i];
      final t = ((progress - p.delay / 3.0) % 1.0 + 1.0) % 1.0;
      if (t < 0.03) continue;
      final x = p.x * size.width + 40 * (t * 2 - 1) * (p.x - 0.5);
      final y = -20 + t * (size.height + 60);
      final opacity = t < 0.1 ? t * 10 : (t > 0.8 ? (1 - t) * 5 : 1.0);
      final paint = Paint()
        ..color = p.color.withOpacity(opacity.clamp(0.0, 0.9))
        ..style = PaintingStyle.fill;
      if (i % 2 == 0) {
        canvas.drawCircle(Offset(x, y), p.size / 2, paint);
      } else {
        canvas.save();
        canvas.translate(x, y);
        canvas.rotate(t * 12.56);
        canvas.drawRect(Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size), paint);
        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => old.progress != progress;
}
