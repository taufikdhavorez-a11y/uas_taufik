import 'dart:ui';
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
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F172A), // Midnight Navy
              Color(0xFF1E293B), // Slate Blue
              Color(0xFF020617), // Deepest Navy
            ],
          ),
        ),
        child: Stack(
          children: [
            // Decorative background elements
            Positioned(
              top: -100,
              right: -50,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF38BDF8).withOpacity(0.05),
                ),
              ).animate(onPlay: (controller) => controller.repeat(reverse: true))
               .move(begin: const Offset(0, 0), end: const Offset(-20, 30), duration: 5.seconds, curve: Curves.easeInOut),
            ),
            
            Positioned(
              bottom: -50,
              left: -50,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF818CF8).withOpacity(0.04),
                ),
              ).animate(onPlay: (controller) => controller.repeat(reverse: true))
               .move(begin: const Offset(0, 0), end: const Offset(30, -20), duration: 7.seconds, curve: Curves.easeInOut),
            ),
            
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'TTS',
                  style: GoogleFonts.outfit(
                    fontSize: 96,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 18,
                    shadows: [
                      Shadow(
                        color: const Color(0xFF38BDF8).withOpacity(0.3),
                        offset: const Offset(0, 4),
                        blurRadius: 30,
                      )
                    ],
                  ),
                ).animate()
                 .fadeIn(duration: 800.ms)
                 .slideY(begin: 0.2, curve: Curves.easeOutBack)
                 .then(delay: 200.ms)
                 .shimmer(duration: 2.seconds, color: Colors.white12),
                
                const SizedBox(height: 8),
                
                Text(
                  'ASAH OTAK SETIAP HARI',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.5),
                    letterSpacing: 8,
                    fontWeight: FontWeight.w600,
                  ),
                ).animate()
                 .fadeIn(delay: 400.ms)
                 .slideY(begin: 1, duration: 600.ms),
                
                const SizedBox(height: 100),
                
                _buildDifficultyButton(context, 'MUDAH', Difficulty.mudah, const Color(0xFF10B981))
                    .animate().fadeIn(delay: 600.ms).slideY(begin: 0.3, curve: Curves.easeOutQuad),
                _buildDifficultyButton(context, 'MENENGAH', Difficulty.menengah, const Color(0xFFF59E0B))
                    .animate().fadeIn(delay: 750.ms).slideY(begin: 0.3, curve: Curves.easeOutQuad),
                _buildDifficultyButton(context, 'SULIT', Difficulty.sulit, const Color(0xFFEF4444))
                    .animate().fadeIn(delay: 900.ms).slideY(begin: 0.3, curve: Curves.easeOutQuad),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyButton(BuildContext context, String title, Difficulty difficulty, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 48),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1.2,
              ),
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 72),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 24),
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      fontSize: 16, 
                      fontWeight: FontWeight.w700, 
                      letterSpacing: 4,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      shape: BoxShape.circle,
                      border: Border.all(color: color.withOpacity(0.3)),
                    ),
                    child: Icon(Icons.arrow_forward_ios, size: 12, color: color),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
