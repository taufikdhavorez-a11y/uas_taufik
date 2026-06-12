import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class SoundService {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> playSuccess() async {
    try {
      // Adjusted to match actual file name: succes.1.mp3
      await _player.play(AssetSource('sounds/succes.1.mp3'));
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
  }

  static void dispose() {
    _player.dispose();
  }
}
