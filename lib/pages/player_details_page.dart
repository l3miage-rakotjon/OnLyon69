import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../services/translation_service.dart';


class PlayerDetailsPage extends StatefulWidget {
  final int playerId;

  const PlayerDetailsPage({super.key, required this.playerId});

  @override
  State<PlayerDetailsPage> createState() => _PlayerDetailsPageState();
}

class _PlayerDetailsPageState extends State<PlayerDetailsPage> {
  final String apiToken = "c7655fc211a544a5ac9234eeb1cc06b6";
  final TranslationService _translationService = TranslationService();
  late Future<Map<String, dynamic>> futurePlayer;

  @override
  void initState() {
    super.initState();
    futurePlayer = fetchPlayerDetails();
  }

  Future<Map<String, dynamic>> fetchPlayerDetails() async {
    final url = Uri.parse("https://api.football-data.org/v4/persons/${widget.playerId}");
    final response = await http.get(url, headers: {"X-Auth-Token": apiToken});

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Erreur API : ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: futurePlayer,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text("Erreur: ${snapshot.error}", style: const TextStyle(color: Colors.red))));
        } else if (snapshot.hasData) {
          final player = snapshot.data!;

          final String name = player['name'] ?? "Inconnu";
          final String firstName = player['firstName'] ?? "";
          final String lastName = player['lastName'] ?? "";
          final String nationality = player['nationality'] ?? "Inconnue";
          final String position = _translationService.translatePosition(player['position'] ?? player['section']);
          final String dob = player['dateOfBirth'] ?? "Non renseignée";
          final int? shirtNumber = player['shirtNumber'];
          final contract = player['currentTeam']?['contract'];
          final String contractStart = contract?['start'] ?? "N/A";
          final String contractUntil = contract?['until'] ?? "N/A";

          return Scaffold(
            appBar: AppBar(
              title: Text(name),
              backgroundColor: const Color(0xFF14387F),
              foregroundColor: Colors.white,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.red.shade700,
                    foregroundColor: Colors.white,
                    child: Text(
                      shirtNumber != null ? "$shirtNumber" : "?",
                      style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(firstName, style: const TextStyle(fontSize: 20)),
                  Text(lastName.toUpperCase(), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  Text(position, style: TextStyle(fontSize: 18, color: Colors.blue.shade800, fontWeight: FontWeight.w600)),

                  const Divider(height: 40),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Informations", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.public),
                          title: const Text("Nationalité"),
                          trailing: Text(nationality, style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        const Divider(height: 0),
                        ListTile(
                          leading: const Icon(Icons.cake),
                          title: const Text("Date de naissance"),
                          trailing: Text(dob, style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Contrat avec l'OL", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.handshake),
                          title: const Text("Début du contrat"),
                          trailing: Text(contractStart, style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        const Divider(height: 0),
                        ListTile(
                          leading: const Icon(Icons.event_available),
                          title: const Text("Fin du contrat"),
                          trailing: Text(contractUntil, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return const Scaffold(body: Center(child: Text("Aucune donnée disponible.")));
      },
    );
  }
}