import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';

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

  Widget _buildLogo(String url) {
    if (url.isEmpty) return const Icon(Icons.shield, size: 40, color: Colors.grey);
    if (url.endsWith('.svg')) {
      return SvgPicture.network(url, height: 40, width: 40,
          placeholderBuilder: (context) => const SizedBox(height: 40, width: 40, child: CircularProgressIndicator(strokeWidth: 2)));
    }
    return Image.network(url, height: 40, width: 40,
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.shield, size: 40, color: Colors.grey));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text("Notre prochain match :", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
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
                          Expanded(child: Column(children: [_buildLogo(homeLogo), const SizedBox(height: 8), Text(homeTeam, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold))])),
                          const Text("VS", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.grey)),
                          Expanded(child: Column(children: [_buildLogo(awayLogo), const SizedBox(height: 8), Text(awayTeam, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold))])),
                        ],
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