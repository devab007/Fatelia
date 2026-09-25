import 'package:flutter/material.dart';

class AppColors {
  // Dégradé principal Turquoise / Menthe (comme sur les cartes et le header)
  static const Color primaryGradientStart = Color(0xFF10B981); // Vert menthe
  static const Color primaryGradientEnd = Color(0xFF06B6D4);   // Turquoise vif

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryGradientStart, primaryGradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Ajouter ces constantes manquantes :
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color cardBorder = Color(0xFFE2E8F0);

  // Couleurs de fond et de surface
  static const Color background = Color(0xFFF8FAFC); // Gris/Bleu très clair
  static const Color cardBackground = Colors.white;

  // Couleurs d'accentuation (Statistiques)
  static const Color orangeAccent = Color(0xFFF97316); // Pour la pression / alertes
  static const Color yellowAccent = Color(0xFFF59E0B); // Pour cholestérol / vaccins
  static const Color blueAccent = Color(0xFF3B82F6);   // Pour le pouls / RDV

  // Textes
  static const Color textDark = Color(0xFF0F172A);
  static const Color textMuted = Color(0xFF94A3B8);
}