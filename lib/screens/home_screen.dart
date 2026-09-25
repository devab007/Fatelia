import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../core/theme/app_colors.dart';
import 'widgets/welcome_banner.dart';
import 'widgets/stat_card.dart';
import 'widgets/voice_assistant_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'DASHBOARD',
          style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.bell, color: AppColors.textDark),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Bannière d'accueil avec Docteur
            WelcomeBanner(
              userName: 'Modou',
              onActionPressed: () {},
            ),

            const SizedBox(height: 16),

            // 2. Les 3 cartes de statistiques de santé
            const Row(
              children: [
                StatCard(
                  value: '105/90',
                  label: 'Tension',
                  icon: LucideIcons.droplet,
                  iconBgColor: Color(0xFFFEE2E2),
                  iconColor: AppColors.orangeAccent,
                ),
                SizedBox(width: 8),
                StatCard(
                  value: '217',
                  label: 'Cholestérol',
                  icon: LucideIcons.activity,
                  iconBgColor: Color(0xFFFEF3C7),
                  iconColor: AppColors.yellowAccent,
                ),
                SizedBox(width: 8),
                StatCard(
                  value: '70',
                  label: 'Pouls',
                  icon: LucideIcons.heartPulse,
                  iconBgColor: Color(0xFFDBEAFE),
                  iconColor: AppColors.blueAccent,
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 3. Widget IA Vocale Kiriku
            // 3. Widget IA Vocale Kiriku
            VoiceAssistantCard(
              onResponseReceived: (transcription, responseText) {
                print("Transcription : $transcription");
                print("Réponse : $responseText");
              },
            ),

            const SizedBox(height: 20),

            // 4. Section Prochain RDV / Rappel
            const Text(
              'Rappels du jour',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Row(
                children: [
                  Icon(LucideIcons.pill, color: AppColors.primaryGradientStart, size: 28),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Paracétamol - 500mg', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Après le repas • 14:00', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                      ],
                    ),
                  ),
                  Icon(LucideIcons.volume2, color: AppColors.primaryGradientStart),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}