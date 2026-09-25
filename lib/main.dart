import 'package:flutter/material.dart';
import 'core/theme/app_colors.dart';
import 'screens/main_navigation_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const KirikuHealthApp());
}

class KirikuHealthApp extends StatelessWidget {
  const KirikuHealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kiriku Health Voice',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryGradientStart,
          primary: AppColors.primaryGradientStart,
          surface: AppColors.background,
        ),
        // Utilisation de la typographie système native (Roboto sur Android, San Francisco sur iOS)
        fontFamily: 'sans-serif',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
        ),
      ),
      // Point d'entrée sur la barre de navigation
      home: const MainNavigationScreen(),
    );
  }
}