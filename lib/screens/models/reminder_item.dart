import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

enum ReminderType { medication, appointment, vaccine }

class ReminderItem {
  final ReminderType type;
  final String title;
  final String subtitle;
  final DateTime dateTime;

  const ReminderItem({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.dateTime,
  });

  IconData get icon {
    switch (type) {
      case ReminderType.medication:
        return LucideIcons.pill;
      case ReminderType.appointment:
        return LucideIcons.calendarClock;
      case ReminderType.vaccine:
        return LucideIcons.syringe;
    }
  }
}