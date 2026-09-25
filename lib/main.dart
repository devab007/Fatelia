/*import 'package:flutter/material.dart';
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
}*/

import 'package:flutter/material.dart';
import 'core/theme/app_colors.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/login_screen.dart';
import 'services/auth_service.dart';

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
      // Point d'entrée : vérifie s'il existe une session enregistrée
      home: const AuthGate(),
    );
  }
}

/// Redirige vers l'app si une session est déjà enregistrée, sinon vers la connexion.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthService.isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: CircularProgressIndicator(color: AppColors.primaryGradientStart),
            ),
          );
        }

        final loggedIn = snapshot.data ?? false;
        return loggedIn ? const MainNavigationScreen() : const LoginScreen();
      },
    );
  }
}