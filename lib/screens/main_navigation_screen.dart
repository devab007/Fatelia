import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import 'home_screen.dart';
import 'medications_screen.dart';
import 'appointments_screen.dart';
import 'profile_screen.dart';
import 'ai_voice_screen.dart'; // 1. Remplacer ai_chat_screen.dart par ai_voice_screen.dart

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    MedicationsScreen(),
    AppointmentsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),

      // Bouton Central pour l'IA
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AiVoiceScreen(), // 2. Instancier AiVoiceScreen()
            ),
          );
        },
        backgroundColor: AppColors.primaryGradientStart,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.mic, // Astuce : vous pouvez aussi remplacer Icons.auto_awesome par Icons.mic si c'est pour de la voix
          color: Colors.white,
          size: 28,
        ),
      ),

      // Barre de navigation personnalisée avec encoche
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Accueil',
                index: 0,
              ),
              _buildNavItem(
                icon: Icons.medication_outlined,
                activeIcon: Icons.medication,
                label: 'Rappels',
                index: 1,
              ),
              const SizedBox(width: 48), // Espace réservé pour le FAB central
              _buildNavItem(
                icon: Icons.calendar_today_outlined,
                activeIcon: Icons.calendar_today,
                label: 'Rdv',
                index: 2,
              ),
              _buildNavItem(
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: 'Profil',
                index: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final isSelected = _currentIndex == index;
    final color = isSelected ? AppColors.primaryGradientStart : Colors.grey;

    return InkWell(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSelected ? activeIcon : icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}