import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../core/theme/app_colors.dart';

class MedicationsScreen extends StatefulWidget {
  const MedicationsScreen({super.key});

  @override
  State<MedicationsScreen> createState() => _MedicationsScreenState();
}

class _MedicationsScreenState extends State<MedicationsScreen> {
  int _selectedCategory = 0; // 0: Tout, 1: Médicaments, 2: Vaccins

  final List<Map<String, dynamic>> _reminders = [
    {
      'id': '1',
      'title': 'Paracétamol 500mg',
      'instruction': 'Lekk ba noppi soga jël garab gi (Prendre après le repas)',
      'time': '08:00',
      'type': 'medication',
      'dosage': '1 comprimé',
      'isTaken': true,
      'audioUrl': 'paracetamol_wolof.mp3',
    },
    {
      'id': '2',
      'title': 'Amoxicilline',
      'instruction': 'Jël ko ak ndox mu barri (Prendre avec beaucoup d\'eau)',
      'time': '14:00',
      'type': 'medication',
      'dosage': '2 gélules',
      'isTaken': false,
      'audioUrl': 'amoxicilline_wolof.mp3',
    },
    {
      'id': '3',
      'title': 'Vaccin BCG (Rappel)',
      'instruction': 'Fajkat bi mungi la xaar ci fajjukaay bi (Rendez-vous au centre de santé)',
      'time': 'Demain - 09:00',
      'type': 'vaccine',
      'dosage': 'Dose 2',
      'isTaken': false,
      'audioUrl': 'bcg_wolof.mp3',
    },
  ];

  void _toggleTaken(String id) {
    setState(() {
      final index = _reminders.indexWhere((item) => item['id'] == id);
      if (index != -1) {
        _reminders[index]['isTaken'] = !_reminders[index]['isTaken'];
      }
    });
  }

  void _playAudioInstruction(String instructionText) {
    // Simulation de la lecture vocale (TTS / Audio)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(LucideIcons.volume2, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(child: Text('Lecture vocale : "$instructionText"')),
          ],
        ),
        backgroundColor: AppColors.primaryGradientStart,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _reminders.where((item) {
      if (_selectedCategory == 1) return item['type'] == 'medication';
      if (_selectedCategory == 2) return item['type'] == 'vaccine';
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Garab ak Rappel (Soins)',
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filtres par onglets
            // Filtres par onglets (scrollable pour éviter le débordement)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip(0, 'Lépp (Tout)'),
                  const SizedBox(width: 8),
                  _buildFilterChip(1, 'Garab (Médicaments)'),
                  const SizedBox(width: 8),
                  _buildFilterChip(2, 'Vaccins'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Liste des rappels
            Expanded(
              child: filteredList.isEmpty
                  ? const Center(child: Text('Amul benn rappel (Aucun rappel)'))
                  : ListView.builder(
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final item = filteredList[index];
                  final bool isVaccine = item['type'] == 'vaccine';

                  return Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(
                        color: item['isTaken']
                            ? Colors.green.withOpacity(0.3)
                            : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // Icône type
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isVaccine
                                    ? AppColors.blueAccent.withOpacity(0.12)
                                    : AppColors.primaryGradientStart.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(
                                isVaccine ? LucideIcons.syringe : LucideIcons.pill,
                                color: isVaccine ? AppColors.blueAccent : AppColors.primaryGradientStart,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Titre et heure
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['title'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      decoration: item['isTaken']
                                          ? TextDecoration.lineThrough
                                          : null,
                                      color: item['isTaken']
                                          ? AppColors.textMuted
                                          : AppColors.textDark,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${item['time']} • ${item['dosage']}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textMuted,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Bouton Check (Pris / Non pris)
                            IconButton(
                              onPressed: () => _toggleTaken(item['id']),
                              icon: Icon(
                                item['isTaken']
                                    ? LucideIcons.checkCircle2
                                    : LucideIcons.circle,
                                color: item['isTaken'] ? Colors.green : AppColors.textMuted,
                                size: 26,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Consigne en langue locale + Bouton d'écoute audio
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item['instruction'],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textDark,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () => _playAudioInstruction(item['instruction']),
                                icon: const Icon(
                                  LucideIcons.volume2,
                                  color: AppColors.primaryGradientStart,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(int index, String label) {
    final isSelected = _selectedCategory == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryGradientStart : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: AppColors.primaryGradientStart.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textMuted,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}