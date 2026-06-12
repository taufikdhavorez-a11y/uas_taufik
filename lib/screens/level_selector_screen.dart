import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/game_provider.dart';
import '../models/level_model.dart';
import '../data/game_data.dart';
import 'game_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LevelSelectorScreen extends ConsumerWidget {
  final Difficulty difficulty;

  const LevelSelectorScreen({super.key, required this.difficulty});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final levels = GameData.getLevelsByDifficulty(difficulty);
    final unlockedLevel = ref.watch(levelProgressProvider)[difficulty] ?? 1;
    final color = _getDifficultyColor(difficulty);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          difficulty.name.toUpperCase(),
          style: GoogleFonts.fredoka(
            fontWeight: FontWeight.w900, 
            letterSpacing: 4,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.white.withValues(alpha: 0.05),
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
                final isUnlocked = level.levelNumber <= unlockedLevel;
                return _buildLevelCard(context, level, color, index, isUnlocked);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLevelCard(BuildContext context, LevelData level, Color difficultyColor, int index, bool isUnlocked) {
    return Consumer(
      builder: (context, ref, child) {
        final Color accentColor = isUnlocked ? difficultyColor : Colors.white10;

        return InkWell(
          onTap: isUnlocked ? () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GameScreen(level: level)),
            );
          } : null,
          borderRadius: BorderRadius.circular(20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isUnlocked ? [
                  accentColor.withValues(alpha: 0.3),
                  accentColor.withValues(alpha: 0.1),
                ] : [
                  Colors.white.withValues(alpha: 0.05),
                  Colors.white.withValues(alpha: 0.02),
                ],
              ),
              border: Border.all(
                color: isUnlocked 
                  ? accentColor.withValues(alpha: 0.6) 
                  : Colors.white10,
                width: 1.5,
              ),
              boxShadow: isUnlocked ? [
                BoxShadow(
                  color: accentColor.withValues(alpha: 0.2),
                  blurRadius: 10,
                  spreadRadius: 1,
                )
              ] : [],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'LEVEL',
                  style: GoogleFonts.fredoka(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                    color: isUnlocked 
                      ? accentColor.withValues(alpha: 0.9) 
                      : Colors.white24,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${level.levelNumber}',
                  style: GoogleFonts.lilitaOne(
                    fontSize: 34,
                    color: isUnlocked 
                      ? Colors.white 
                      : Colors.white10,
                  ),
                ),
                if (!isUnlocked)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Icon(
                      Icons.lock_rounded,
                      size: 14,
                      color: Colors.white24,
                    ),
                  ),
              ],
            ),
          ),
        ).animate().scale(
          duration: 400.ms,
          begin: const Offset(0.9, 0.9),
          end: const Offset(1, 1),
          curve: Curves.easeOutBack,
        ).fadeIn(delay: (index * 40).ms);
      }
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
