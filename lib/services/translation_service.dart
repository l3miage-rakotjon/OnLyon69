import 'package:flutter/material.dart';

class TranslationService {
  String translatePosition(String? position) {
    switch (position) {
      case "Goalkeeper": return "Gardien";
      case "Defence": return "Défenseur";
      case "Midfield": return "Milieu";
      case "Offence": return "Attaquant";
      case "Defensive Midfield": return "Milieu Défensif";
      case "Attacking Midfield": return "Milieu Offensif";
      case "Right-Back": return "Latéral Droit";
      case "Left-Back": return "Latéral Gauche";
      case "Centre-Back": return "Défenseur Central";
      case "Central Midfield": return "Milieu Central";
      case "Left Winger": return "Ailier Gauche";
      case "Right Winger": return "Ailier Droit";
      case "Centre-Forward": return "Avant-centre";
      default: return position ?? "Staff technique";
    }
  }

  IconData getPositionIcon(String? position) {
    switch (position) {
      case "Goalkeeper": return Icons.back_hand;
      case "Defence": return Icons.shield;
      case "Midfield": return Icons.directions_run;
      case "Offence": return Icons.sports_soccer;
      case "Defensive Midfield": return Icons.directions_run;
      case "Attacking Midfield": return Icons.auto_fix_high;
      case "Right-Back": return Icons.shield;
      case "Left-Back": return Icons.shield;
      case "Centre-Back": return Icons.shield;
      case "Central Midfield": return Icons.auto_fix_high;
      case "Left Winger": return Icons.bolt;
      case "Right Winger": return Icons.bolt;
      case "Centre-Forward": return Icons.sports_soccer;
      default: return Icons.person;
    }
  }
}