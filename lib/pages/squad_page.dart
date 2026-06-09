import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../pages/player_details_page.dart';
import '../services/translation_service.dart';


class SquadPage extends StatefulWidget {
  const SquadPage({super.key});

  @override
  State<SquadPage> createState() => _SquadPageState();
}

class _SquadPageState extends State<SquadPage> {
  final String apiToken = "c7655fc211a544a5ac9234eeb1cc06b6";
  final String teamId = "523";
  final TranslationService _translationService = TranslationService();

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

                final String dob = player['dateOfBirth'] ?? "";
                final String birthYear = dob.isNotEmpty && dob.length >= 4 ? dob.substring(0, 4) : "";

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: ListTile(
                    onTap: () {
                      final int playerId = player['id'];

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PlayerDetailsPage(playerId: playerId),
                        ),
                      );
                    },
                    leading: CircleAvatar(
                      backgroundColor: Colors.red.shade50,
                      foregroundColor: Colors.red.shade700,
                      child: Icon(_translationService.getPositionIcon(player['position'])),
                    ),
                    title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("${_translationService.translatePosition(position)} • $nationality"),
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