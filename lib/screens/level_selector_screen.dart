import 'dart:ui';
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
          difficulty.name.toUpperCase(),
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w900, 
            letterSpacing: 4,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.white.withOpacity(0.05),
        elevation: 0,
        centerTitle: true,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.transparent),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFF0F172A),
              Color(0xFF020617),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: GridView.builder(
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
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
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.white.withOpacity(0.08), 
            width: 1.2,
          ),
        ),
        child: Center(
          child: Text(
            '${level.levelNumber}',
            style: GoogleFonts.outfit(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: (index * 50).ms).scale(
      curve: Curves.easeOutBack,
      begin: const Offset(0.8, 0.8),
    );
  }

  Color _getDifficultyColor(Difficulty diff) {
    switch (diff) {
      case Difficulty.mudah: return const Color(0xFF10B981);
      case Difficulty.menengah: return const Color(0xFFF59E0B);
      case Difficulty.sulit: return const Color(0xFFEF4444);
    }
  }
}
