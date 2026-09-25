/*import 'package:flutter/material.dart';
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
}*/
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../core/theme/app_colors.dart';
import '../core/i18n/app_strings.dart';
import '../services/auth_service.dart';
import 'models/reminder_item.dart';
import 'widgets/welcome_banner.dart';
import 'widgets/stat_card.dart';
import 'widgets/voice_assistant_card.dart';
import 'widgets/reminder_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // TODO: remplacer par les vraies données du backend (médicaments, RDV,
  // vaccins) dès que ces routes existeront côté API — comme pour l'ASR,
  // ce sont pour l'instant des données simulées.
  List<ReminderItem> get _todayReminders => [
    ReminderItem(
      type: ReminderType.medication,
      title: 'Paracétamol - 500mg',
      subtitle: 'Après le repas',
      dateTime: DateTime.now().copyWith(hour: 14, minute: 0),
    ),
    ReminderItem(
      type: ReminderType.appointment,
      title: 'Consultation Dr. Diop',
      subtitle: 'Centre de santé Grand Yoff',
      dateTime: DateTime.now().add(const Duration(days: 2, hours: 3)),
    ),
    ReminderItem(
      type: ReminderType.vaccine,
      title: 'Rappel Tétanos',
      subtitle: 'Poste de santé quartier',
      dateTime: DateTime.now().add(const Duration(days: 9)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;
    final userName = (user?['full_name'] as String?)?.split(' ').first ?? 'Ami(e)';
    final language = (user?['language'] as String?) ?? 'Wolof';

    final reminders = _todayReminders;
    final medicationsToday = reminders.where((r) => r.type == ReminderType.medication).length;

    final appointments = reminders.where((r) => r.type == ReminderType.appointment).toList();
    final nextAppointment = appointments.isEmpty
        ? null
        : appointments.reduce((a, b) => a.dateTime.isBefore(b.dateTime) ? a : b);

    final vaccines = reminders.where((r) => r.type == ReminderType.vaccine).toList();
    final nextVaccine = vaccines.isEmpty
        ? null
        : vaccines.reduce((a, b) => a.dateTime.isBefore(b.dateTime) ? a : b);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 16, // espace à gauche
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(LucideIcons.bot, color: AppColors.textDark, size: 18),
                const SizedBox(width: 6),
                const Text(
                  'Fatelia',
                  style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            Text(
              AppStrings.shortDateFr(DateTime.now()),
              style: const TextStyle(color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        actions: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: const Icon(LucideIcons.bell, color: AppColors.textDark),
                onPressed: () {},
              ),
              if (reminders.isNotEmpty)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: AppColors.orangeAccent,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${reminders.length}',
                      style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dans home_screen.dart
            WelcomeBanner(
              userName: userName,
              onActionPressed: () {},
            ),

            const SizedBox(height: 16),

            // 2. Les 3 cartes de statistiques santé pertinentes pour l'app
            Row(
              children: [
                StatCard(
                  value: '$medicationsToday',
                  label: "Médicaments aujourd'hui",
                  icon: LucideIcons.pill,
                  iconBgColor: const Color(0xFFFEE2E2),
                  iconColor: AppColors.orangeAccent,
                ),
                const SizedBox(width: 8),
                StatCard(
                  value: nextAppointment != null ? AppStrings.shortDateFr(nextAppointment.dateTime) : '—',
                  label: 'Prochain RDV',
                  icon: LucideIcons.calendarClock,
                  iconBgColor: const Color(0xFFDBEAFE),
                  iconColor: AppColors.blueAccent,
                ),
                const SizedBox(width: 8),
                StatCard(
                  value: nextVaccine != null ? AppStrings.shortDateFr(nextVaccine.dateTime) : '—',
                  label: 'Prochain vaccin',
                  icon: LucideIcons.syringe,
                  iconBgColor: const Color(0xFFFEF3C7),
                  iconColor: AppColors.yellowAccent,
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 3. Widget IA Vocale Kiriku (langue initiale = langue du compte)
            VoiceAssistantCard(
              initialLanguage: language,
              onResponseReceived: (transcription, responseText) {
                debugPrint('Transcription : $transcription');
                debugPrint('Réponse : $responseText');
              },
            ),

            const SizedBox(height: 20),

            // 4. Liste des rappels du jour (dynamique)
            const Text(
              'Rappels du jour',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark),
            ),
            const SizedBox(height: 10),

            if (reminders.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Text(
                  "Aucun rappel pour aujourd'hui.",
                  style: TextStyle(color: AppColors.textMuted),
                ),
              )
            else
              Column(
                children: [
                  for (final reminder in reminders) ...[
                    ReminderTile(reminder: reminder),
                    const SizedBox(height: 10),
                  ],
                ],
              ),
          ],
        ),
      ),
    );
  }
}