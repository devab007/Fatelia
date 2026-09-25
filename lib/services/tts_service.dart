import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  static final FlutterTts _flutterTts = FlutterTts();
  static bool _isInitialized = false;

  /// Initialise les paramètres du moteur vocal
  static Future<void> init() async {
    if (_isInitialized) return;

    await _flutterTts.setLanguage("fr-FR");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.45); // Vitesse adaptée pour les réponses

    _isInitialized = true;
  }

  /// Lit un texte à haute voix
  static Future<void> speak(String text) async {
    if (text.trim().isEmpty) return;
    await init();
    await _flutterTts.stop(); // Stoppe toute lecture en cours
    await _flutterTts.speak(text);
  }

  /// Arrête la lecture vocale
  static Future<void> stop() async {
    await _flutterTts.stop();
  }
}