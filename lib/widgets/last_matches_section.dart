import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';

class LastMatchesSection extends StatefulWidget {
  const LastMatchesSection({super.key});

  @override
  State<LastMatchesSection> createState() => _LastMatchesSectionState();
}

class _LastMatchesSectionState extends State<LastMatchesSection> {
  final String apiToken = "c7655fc211a544a5ac9234eeb1cc06b6";
  final String teamId = "523";

  late Future<List<dynamic>> futureLastMatches;

  @override
  void initState() {
    super.initState();
    futureLastMatches = fetchLastMatches();
  }

  Future<List<dynamic>> fetchLastMatches() async {
    final url = Uri.parse("https://api.football-data.org/v4/teams/$teamId/matches?status=FINISHED&limit=5");
    final response = await http.get(url, headers: {"X-Auth-Token": apiToken});

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['matches'] != null && data['matches'].isNotEmpty) {
        return data['matches'].reversed.toList();
      }
      return [];
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
            child: Text("Nos 5 derniers matchs :", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ),
        FutureBuilder<List<dynamic>>(
          future: futureLastMatches,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Padding(padding: EdgeInsets.all(20.0), child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text("Erreur: ${snapshot.error}", style: const TextStyle(color: Colors.red));
            } else if (snapshot.hasData) {
              final matches = snapshot.data!;

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: matches.length,
                itemBuilder: (context, index) {
                  final match = matches[index];
                  final homeTeam = match['homeTeam']['name'] ?? match['homeTeam']['name'];
                  final awayTeam = match['awayTeam']['name'] ?? match['awayTeam']['name'];
                  final homeScore = match['score']['fullTime']['home'];
                  final awayScore = match['score']['fullTime']['away'];
                  final String homeLogo = match['homeTeam']['crest'] ?? "";
                  final String awayLogo = match['awayTeam']['crest'] ?? "";
                  final date = match['utcDate'].toString().substring(0, 10);

                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text("${match['competition']['name']} - $date", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(child: Column(children: [_buildLogo(homeLogo), const SizedBox(height: 8), Text(homeTeam, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold))])),
                              Text("$homeScore - $awayScore", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue)),
                              Expanded(child: Column(children: [_buildLogo(awayLogo), const SizedBox(height: 8), Text(awayTeam, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold))])),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            return const Text("Aucune donnée disponible");
          },
        ),
      ],
    );
  }
}