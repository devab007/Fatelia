/*import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../services/audio_service.dart';
import '../../services/api_service.dart';

class VoiceAssistantCard extends StatefulWidget {
  final Function(String transcription, String responseText)? onResponseReceived;

  const VoiceAssistantCard({super.key, this.onResponseReceived});

  @override
  State<VoiceAssistantCard> createState() => _VoiceAssistantCardState();
}

class _VoiceAssistantCardState extends State<VoiceAssistantCard> {
  final AudioService _audioService = AudioService();
  bool isListening = false;
  bool isLoading = false;
  String selectedLanguage = 'Wolof';

  String? transcriptionText;
  String? responseText;

  final List<String> languages = ['Wolof', 'Pulaar', 'Sérère', 'Français'];

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }

  Future<void> _handleMicPress() async {
    if (isLoading) return;

    if (!isListening) {
      // Démarrer l'enregistrement
      try {
        await _audioService.startRecording();
        setState(() {
          isListening = true;
          transcriptionText = null;
          responseText = null;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur micro : $e')),
        );
      }
    } else {
      // Arrêter l'enregistrement et envoyer à l'API
      setState(() {
        isListening = false;
        isLoading = true;
      });

      final filePath = await _audioService.stopRecording();

      if (filePath != null) {
        final res = await ApiService.sendAudioToASR(filePath, selectedLanguage);

        setState(() {
          isLoading = false;
          if (res['success'] == true) {
            transcriptionText = res['transcription'];
            responseText = res['response_text'];

            if (widget.onResponseReceived != null) {
              widget.onResponseReceived!(
                res['transcription'],
                res['response_text'],
              );
            }
          } else {
            responseText = "Erreur : ${res['error']}";
          }
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // En-tête : Titre & Sélecteur de Langue
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGradientStart.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(LucideIcons.sparkles, color: AppColors.primaryGradientStart, size: 16),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'IA Kiriku Voice',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textDark),
                  ),
                ],
              ),
              // Menu déroulant langue
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedLanguage,
                    icon: const Icon(LucideIcons.chevronDown, size: 14, color: AppColors.textMuted),
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textDark),
                    items: languages.map((lang) {
                      return DropdownMenuItem(value: lang, child: Text(lang));
                    }).toList(),
                    onChanged: (val) => setState(() => selectedLanguage = val!),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Bouton Micro Interactif
          GestureDetector(
            onTap: _handleMicPress,
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (isListening)
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryGradientStart.withOpacity(0.2),
                    ),
                  ).animate(onPlay: (c) => c.repeat())
                      .scale(begin: const Offset(1, 1), end: const Offset(1.4, 1.4), duration: 1200.ms)
                      .fadeOut(duration: 1200.ms),

                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: isListening
                        ? const LinearGradient(colors: [Color(0xFFEF4444), Color(0xFFDC2626)])
                        : AppColors.primaryGradient,
                    boxShadow: [
                      BoxShadow(
                        color: (isListening ? Colors.red : AppColors.primaryGradientStart).withOpacity(0.35),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 3)
                      : Icon(
                    isListening ? LucideIcons.square : LucideIcons.mic,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          Text(
            isLoading
                ? 'Traitement ASR en cours...'
                : isListening
                ? 'Déglu nañu sa wax... (Appuyez pour arrêter)'
                : 'Bëssal bouton bi ngir wax',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: isListening ? AppColors.primaryGradientStart : AppColors.textMuted,
            ),
          ),

          // Affichage de la transcription et de la réponse Kiriku
          if (transcriptionText != null || responseText != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (transcriptionText != null) ...[
                    Text(
                      '🗣️ " $transcriptionText "',
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  if (responseText != null)
                    Row(
                      children: [
                        const Icon(LucideIcons.bot, size: 18, color: AppColors.primaryGradientStart),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            responseText!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryGradientStart,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}*/
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/i18n/app_strings.dart';
import '../../services/audio_service.dart';
import '../../services/api_service.dart';
import 'package:flutter_tts/flutter_tts.dart';

final FlutterTts flutterTts = FlutterTts();

Future<void> speakResponse(String text) async {
  await flutterTts.setLanguage("fr-FR"); // Ou la langue configurée
  await flutterTts.setPitch(1.0);
  await flutterTts.setSpeechRate(0.5); // Vitesse normale
  await flutterTts.speak(text);
}

class VoiceAssistantCard extends StatefulWidget {
  final Function(String transcription, String responseText)? onResponseReceived;
  /// Langue par défaut au premier affichage (ex: la langue du compte utilisateur).
  /// L'utilisateur peut toujours la changer via le sélecteur.
  final String? initialLanguage;

  const VoiceAssistantCard({super.key, this.onResponseReceived, this.initialLanguage});

  @override
  State<VoiceAssistantCard> createState() => _VoiceAssistantCardState();
}

class _VoiceAssistantCardState extends State<VoiceAssistantCard> {
  final AudioService _audioService = AudioService();
  bool isListening = false;
  bool isLoading = false;
  late String selectedLanguage;

  String? transcriptionText;
  String? responseText;

  final List<String> languages = AppStrings.supportedLanguages;

  @override
  void initState() {
    super.initState();
    selectedLanguage = widget.initialLanguage ?? 'Wolof';
  }

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }

  Future<void> _handleMicPress() async {
    if (isLoading) return;

    if (!isListening) {
      // Démarrer l'enregistrement
      try {
        await _audioService.startRecording();
        setState(() {
          isListening = true;
          transcriptionText = null;
          responseText = null;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur micro : $e')),
        );
      }
    } else {
      // Arrêter l'enregistrement et envoyer à l'API
      setState(() {
        isListening = false;
        isLoading = true;
      });

      final filePath = await _audioService.stopRecording();

      if (filePath != null) {
        final res = await ApiService.sendAudioToASR(filePath, selectedLanguage);

        setState(() {
          isLoading = false;
          if (res['success'] == true) {
            transcriptionText = res['transcription'];
            responseText = res['response_text'];

            if (widget.onResponseReceived != null) {
              widget.onResponseReceived!(
                res['transcription'],
                res['response_text'],
              );
            }
          } else {
            responseText = "Erreur : ${res['error']}";
          }
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // En-tête : Titre & Sélecteur de Langue
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGradientStart.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(LucideIcons.sparkles, color: AppColors.primaryGradientStart, size: 16),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'IA Kiriku Voice',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textDark),
                  ),
                ],
              ),
              // Menu déroulant langue
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedLanguage,
                    icon: const Icon(LucideIcons.chevronDown, size: 14, color: AppColors.textMuted),
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textDark),
                    items: languages.map((lang) {
                      return DropdownMenuItem(value: lang, child: Text(lang));
                    }).toList(),
                    onChanged: (val) => setState(() => selectedLanguage = val!),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Bouton Micro Interactif
          GestureDetector(
            onTap: _handleMicPress,
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (isListening)
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryGradientStart.withOpacity(0.2),
                    ),
                  ).animate(onPlay: (c) => c.repeat())
                      .scale(begin: const Offset(1, 1), end: const Offset(1.4, 1.4), duration: 1200.ms)
                      .fadeOut(duration: 1200.ms),

                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: isListening
                        ? const LinearGradient(colors: [Color(0xFFEF4444), Color(0xFFDC2626)])
                        : AppColors.primaryGradient,
                    boxShadow: [
                      BoxShadow(
                        color: (isListening ? Colors.red : AppColors.primaryGradientStart).withOpacity(0.35),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 3)
                      : Icon(
                    isListening ? LucideIcons.square : LucideIcons.mic,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          Text(
            isLoading
                ? 'Traitement ASR en cours...'
                : isListening
                ? AppStrings.micListeningPrompt(selectedLanguage)
                : AppStrings.micIdlePrompt(selectedLanguage),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: isListening ? AppColors.primaryGradientStart : AppColors.textMuted,
            ),
          ),

          // Affichage de la transcription et de la réponse Kiriku
          if (transcriptionText != null || responseText != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (transcriptionText != null) ...[
                    Text(
                      '🗣️ " $transcriptionText "',
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  if (responseText != null)
                    Row(
                      children: [
                        const Icon(LucideIcons.bot, size: 18, color: AppColors.primaryGradientStart),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            responseText!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryGradientStart,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}