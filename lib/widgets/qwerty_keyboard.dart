import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QwertyKeyboard extends StatelessWidget {
  final Function(String) onKeyTap;
  final VoidCallback onDeleteTap;

  const QwertyKeyboard({
    super.key,
    required this.onKeyTap,
    required this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    const List<List<String>> keys = [
      ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
      ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
      ['Z', 'X', 'C', 'V', 'B', 'N', 'M'],
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      color: const Color(0xFFFA6E5A), // Match the reddish/coral keyboard bg
      child: Column(
        children: [
          for (var row in keys)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var key in row)
                    _buildKey(key),
                  if (keys.indexOf(row) == 2) // Add delete key to the last row
                    _buildSpecialKey(Icons.backspace_outlined, onDeleteTap),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildKey(String label) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: InkWell(
          onTap: () => onKeyTap(label),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Center(
              child: Text(
                label,
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpecialKey(IconData icon, VoidCallback onTap) {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
        ),
      ),
    );
  }
}
