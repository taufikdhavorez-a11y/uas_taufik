import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/level_model.dart';
import '../data/game_data.dart';
import 'game_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LevelSelectorScreen extends StatelessWidget {
  final Difficulty difficulty;

  const LevelSelectorScreen({super.key, required this.difficulty});

  @override
  Widget build(BuildContext context) {
    final levels = GameData.getLevelsByDifficulty(difficulty);
    final color = _getDifficultyColor(difficulty);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'LEVEL ${difficulty.name.toUpperCase()}',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, letterSpacing: 2),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFFA6E5A),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 1,
              ),
              itemCount: levels.length,
              itemBuilder: (context, index) {
                final level = levels[index];
                return _buildLevelCard(context, level, color, index);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLevelCard(BuildContext context, LevelData level, Color color, int index) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GameScreen(level: level)),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Center(
          child: Text(
            '${level.levelNumber}',
            style: GoogleFonts.outfit(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: (index * 50).ms).scale(curve: Curves.easeOutBack);
  }

  Color _getDifficultyColor(Difficulty diff) {
    switch (diff) {
      case Difficulty.mudah: return Colors.greenAccent;
      case Difficulty.menengah: return Colors.orangeAccent;
      case Difficulty.sulit: return Colors.redAccent;
    }
  }
}
