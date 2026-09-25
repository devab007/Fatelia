import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../core/theme/app_colors.dart';
import '../services/tts_service.dart';

class AiVoiceScreen extends StatefulWidget {
  const AiVoiceScreen({super.key});

  @override
  State<AiVoiceScreen> createState() => _AiVoiceScreenState();
}

class _AiVoiceScreenState extends State<AiVoiceScreen>
    with SingleTickerProviderStateMixin {
  bool _isListening = false;
  String _statusText = 'Appuyez pour parler';

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  final List<Map<String, dynamic>> _chatLogs = [
    {
      'isUser': false,
      'text': 'Salaam! Demandez-moi un rappel médicament, RDV ou vaccin.',
    },
  ];

  final List<String> _suggestions = [
    'Quand prendre mon comprimé ?',
    'Rappelle-moi mon vaccin',
    'Quel est mon prochain RDV ?',
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    TtsService.stop(); // Interrompt toute lecture vocale à la fermeture de l'écran
    super.dispose();
  }

  void _toggleListening([String? customQuery]) {
    if (_isListening && customQuery == null) {
      // Arrêt de l'écoute et du son
      TtsService.stop();
      _pulseController.stop();
      _pulseController.reset();
      setState(() {
        _isListening = false;
        _statusText = 'Appuyez pour parler';
      });
    } else {
      // Démarrage de l'écoute
      TtsService.stop(); // Stoppe un éventuel audio précédent
      _pulseController.repeat(reverse: true);
      setState(() {
        _isListening = true;
        _statusText = customQuery != null ? 'Traitement en cours...' : 'Fatelia vous écoute...';
      });

      // Traitement de la requête vocale
      final query = customQuery ?? 'Quand prendre mon comprimé ?';

      Future.delayed(Duration(seconds: customQuery != null ? 1 : 3), () {
        if (!mounted) return;

        setState(() {
          _chatLogs.add({'isUser': true, 'text': query});
          _statusText = 'Fatelia répond...';
        });

        // Génération de la réponse et déclenchement vocal
        Future.delayed(const Duration(seconds: 1, milliseconds: 500), () {
          if (!mounted) return;

          _pulseController.stop();
          _pulseController.reset();

          final response = _generateMockResponse(query);

          setState(() {
            _isListening = false;
            _statusText = 'Appuyez pour parler';
            _chatLogs.add({
              'isUser': false,
              'text': response,
            });
          });

          // 🔊 Déclenchement de la voix
          TtsService.speak(response);
        });
      });
    }
  }

  String _generateMockResponse(String query) {
    if (query.contains('comprimé')) {
      return 'Vous devez prendre votre Paracétamol 1g à 14h00 après le déjeuner.';
    } else if (query.contains('vaccin')) {
      return 'Votre prochain rappel de vaccin contre l\'Hépatite B est prévu dans 2 mois.';
    } else if (query.contains('RDV')) {
      return 'Votre prochain RDV est fixé au 28/09/2026 à 10:30 avec le Dr. Aminata Diallo.';
    }
    return 'J\'ai bien compris votre demande. Souhaitez-vous enregistrer un rappel ?';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Fatel IA',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            Text(
              'Kiriku VOICE · Santé',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Bandeau d'accueil dynamique
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryGradientStart.withOpacity(0.10),
                      AppColors.primaryGradientEnd.withOpacity(0.06),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryGradientStart.withOpacity(0.35),
                                blurRadius: 14,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: const Icon(LucideIcons.bot, color: Colors.white, size: 26),
                        )
                            .animate(onPlay: (c) => c.repeat(reverse: true))
                            .moveY(begin: 0, end: -5, duration: 1400.ms, curve: Curves.easeInOut),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Fatelia',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Ton assistant santé vocal',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Row(
                      children: [
                        _CapabilityChip(icon: LucideIcons.pill, label: 'Médicaments'),
                        SizedBox(width: 8),
                        _CapabilityChip(icon: LucideIcons.syringe, label: 'Vaccins'),
                        SizedBox(width: 8),
                        _CapabilityChip(icon: LucideIcons.calendarClock, label: 'RDV'),
                      ],
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 450.ms).slideY(begin: 0.08, end: 0),

              const SizedBox(height: 14),

              Text(
                _statusText,
                style: TextStyle(
                  fontSize: 15,
                  color: _isListening ? AppColors.primaryGradientStart : Colors.grey.shade600,
                  fontWeight: _isListening ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              const SizedBox(height: 32),

              // Mic Ring (Bouton animé)
              GestureDetector(
                onTap: () => _toggleListening(),
                child: AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _isListening ? _pulseAnimation.value : 1.0,
                      child: Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _isListening
                              ? AppColors.primaryGradientStart
                              : AppColors.primaryGradientStart.withAlpha(25),
                          boxShadow: _isListening
                              ? [
                            BoxShadow(
                              color: AppColors.primaryGradientStart.withAlpha(80),
                              blurRadius: 25,
                              spreadRadius: 8,
                            )
                          ]
                              : [],
                        ),
                        child: Icon(
                          _isListening ? Icons.graphic_eq : Icons.mic_none_rounded,
                          size: 48,
                          color: _isListening ? Colors.white : AppColors.primaryGradientStart,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Démo · micro simulé · réponses mock',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade400,
                ),
              ),
              const SizedBox(height: 32),

              // Voice Suggestions
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'EXEMPLES',
                  style: TextStyle(
                    fontSize: 11,
                    letterSpacing: 1.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Column(
                children: _suggestions.map((sug) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8.0),
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        alignment: Alignment.centerLeft,
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _isListening ? null : () => _toggleListening(sug),
                      child: Text(
                        sug,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Chat Log Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: _chatLogs.map((log) {
                    final isUser = log['isUser'] as bool;
                    return Align(
                      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: isUser
                              ? AppColors.primaryGradientStart
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: isUser ? null : Border.all(color: Colors.grey.shade200),
                        ),
                        child: Text(
                          log['text'],
                          style: TextStyle(
                            fontSize: 13,
                            color: isUser ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget interne pour afficher les badges sous l'en-tête
class _CapabilityChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _CapabilityChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.primaryGradientStart.withOpacity(0.15),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 14,
              color: AppColors.primaryGradientStart,
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}