import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/level_model.dart';
import 'level_selector_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFFFA6E5A),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'TTS',
              style: GoogleFonts.outfit(
                fontSize: 80,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 12,
              ),
            ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.3, curve: Curves.easeOutBack),
            const SizedBox(height: 10),
            Text(
              'ASAH OTAK SETIAP HARI',
              style: GoogleFonts.outfit(
                fontSize: 14,
                color: Colors.white54,
                letterSpacing: 4,
                fontWeight: FontWeight.w500,
              ),
            ).animate().fadeIn(delay: 400.ms).slideY(begin: 1, duration: 600.ms),
            const SizedBox(height: 80),
            _buildDifficultyButton(context, 'MUDAH', Difficulty.mudah, Colors.greenAccent)
                .animate().fadeIn(delay: 600.ms).slideX(begin: -0.2),
            _buildDifficultyButton(context, 'MENENGAH', Difficulty.menengah, Colors.orangeAccent)
                .animate().fadeIn(delay: 750.ms).slideX(begin: -0.2),
            _buildDifficultyButton(context, 'SULIT', Difficulty.sulit, Colors.redAccent)
                .animate().fadeIn(delay: 900.ms).slideX(begin: -0.2),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyButton(BuildContext context, String title, Difficulty difficulty, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 48),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              spreadRadius: 2,
            )
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFFFA6E5A),
            side: BorderSide(color: Colors.white.withValues(alpha: 0.5), width: 1.5),
            minimumSize: const Size(double.infinity, 64),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 4,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LevelSelectorScreen(difficulty: difficulty),
              ),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2),
              ),
              const SizedBox(width: 12),
              Icon(Icons.arrow_forward_ios, size: 14, color: color.withValues(alpha: 0.7)),
            ],
          ),
        ),
      ),
    );
  }
}
