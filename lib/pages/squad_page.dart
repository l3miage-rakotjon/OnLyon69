import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../pages/player_details_page.dart';

class SquadPage extends StatefulWidget {
  const SquadPage({super.key});

  @override
  State<SquadPage> createState() => _SquadPageState();
}

class _SquadPageState extends State<SquadPage> {
  final String apiToken = "c7655fc211a544a5ac9234eeb1cc06b6";
  final String teamId = "523";

  late Future<List<dynamic>> futureSquad;

  @override
  void initState() {
    super.initState();
    futureSquad = fetchSquad();
  }

  Future<List<dynamic>> fetchSquad() async {
    final url = Uri.parse("https://api.football-data.org/v4/teams/$teamId");
    final response = await http.get(url, headers: {"X-Auth-Token": apiToken});

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['squad'] != null) {
        return data['squad'];
      }
      return [];
    } else {
      throw Exception("Erreur API : ${response.statusCode}");
    }
  }

  // Traduction fr
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
      case "Central Midfield": return "Milieu";
      case "Left Winger": return "Ailier Gauche";
      case "Right Winger": return "Ailier Droit";
      case "Centre-Forward": return "Attaquant de Pointe";
      default: return position ?? "Staff technique";
    }
  }

  // icone suivant les postes
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Effectif de l'OL"),
        backgroundColor: const Color(0xFF14387F),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: futureSquad,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            if (snapshot.error.toString().contains("403")) {
              return const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "Les informations ne sont pas disponibles pour le moment (Intersaison).",
                  style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              );
            }
            return Text("Erreur: ${snapshot.error}", style: const TextStyle(color: Colors.red));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final squad = snapshot.data!;

            return ListView.builder(
              itemCount: squad.length,
              itemBuilder: (context, index) {
                final player = squad[index];
                final String name = player['name'] ?? "Inconnu";
                final String position = player['position'] ?? "";
                final String nationality = player['nationality'] ?? "Inconnue";

                // recupere date de naissance quand renseignée
                final String dob = player['dateOfBirth'] ?? "";
                final String birthYear = dob.isNotEmpty && dob.length >= 4 ? dob.substring(0, 4) : "";

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: ListTile(
                    onTap: () {
                      // On récupère l'ID du joueur depuis l'API
                      final int playerId = player['id'];

                      // On navigue vers la nouvelle page en lui passant l'ID
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PlayerDetailsPage(playerId: playerId),
                        ),
                      );
                    },

                    leading: CircleAvatar(
                      backgroundColor: Colors.red.shade50,
                      foregroundColor: Colors.red.shade700,
                      child: Icon(getPositionIcon(player['position'])),
                    ),
                    title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("${translatePosition(position)} • $nationality"),
                    trailing: birthYear.isNotEmpty
                        ? Text("Né en $birthYear", style: const TextStyle(color: Colors.grey, fontSize: 12))
                        : null,
                  ),
                );
              },
            );
          }
          return const Center(child: Text("Aucun joueur trouvé."));
        },
      ),
    );
  }
}