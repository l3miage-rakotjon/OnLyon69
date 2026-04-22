import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../widgets/team_logo.dart'; // Import du nouveau widget

class NextMatchSection extends StatefulWidget {
  const NextMatchSection({super.key});

  @override
  State<NextMatchSection> createState() => _NextMatchSectionState();
}

class _NextMatchSectionState extends State<NextMatchSection> {
  final String apiToken = "c7655fc211a544a5ac9234eeb1cc06b6";
  final String teamId = "523";

  late Future<Map<String, dynamic>?> futureNextMatch;

  @override
  void initState() {
    super.initState();
    futureNextMatch = fetchNextMatch();
  }

  Future<Map<String, dynamic>?> fetchNextMatch() async {
    final url = Uri.parse("https://api.football-data.org/v4/teams/$teamId/matches?status=SCHEDULED&limit=1");
    final response = await http.get(url, headers: {"X-Auth-Token": apiToken});

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['matches'] != null && data['matches'].isNotEmpty) {
        return data['matches'][0];
      }
      return null;
    } else {
      throw Exception("Erreur API : ${response.statusCode}");
    }
  }

  Future<void> _launchTicketUrl() async {
    final Uri url = Uri.parse('https://billetterie.ol.fr/'); // Le lien vers la billetterie

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Impossible d'ouvrir le lien")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text("Prochain match :", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black)),
          ),
        ),
        FutureBuilder<Map<String, dynamic>?>(
          future: futureNextMatch,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text("Erreur: ${snapshot.error}", style: const TextStyle(color: Colors.red));
            } else if (snapshot.hasData && snapshot.data != null) {
              final match = snapshot.data!;
              final homeTeam = match['homeTeam']['name'] ?? match['homeTeam']['name'];
              final awayTeam = match['awayTeam']['name'] ?? match['awayTeam']['name'];
              final String homeLogo = match['homeTeam']['crest'] ?? "";
              final String awayLogo = match['awayTeam']['crest'] ?? "";

              final utcDate = DateTime.parse(match['utcDate']).toLocal();
              final date = "${utcDate.day.toString().padLeft(2, '0')}/${utcDate.month.toString().padLeft(2, '0')} à ${utcDate.hour.toString().padLeft(2, '0')}h${utcDate.minute.toString().padLeft(2, '0')}";

              return Card(
                color: Colors.red.shade50,
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text("${match['competition']['name']} - $date", style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Column(
                                  children: [
                                    TeamLogo(url: homeLogo),
                                    const SizedBox(height: 8),
                                    Text(homeTeam, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold))
                                  ]
                              )
                          ),
                          const Text("VS", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.grey)),
                          Expanded(
                              child: Column(
                                  children: [
                                    TeamLogo(url: awayLogo),
                                    const SizedBox(height: 8),
                                    Text(awayTeam, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold))
                                  ]
                              )
                          ),
                        ],
                      ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _launchTicketUrl,
                      icon: const Icon(Icons.confirmation_number, color: Colors.white),
                      label: const Text(
                          "Prendre sa place",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade700, // Rouge OL
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                    ],
                  ),
                ),
              );
            }
            return const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text("Aucun match prévu pour le moment.", style: TextStyle(fontStyle: FontStyle.italic)),
            );
          },
        ),
      ],
    );
  }
}