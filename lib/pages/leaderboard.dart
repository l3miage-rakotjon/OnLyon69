import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../widgets/team_logo.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  final String apiToken = "c7655fc211a544a5ac9234eeb1cc06b6";
  final String competitionId = "2015";
  final int myTeamId = 523;

  late Future<List<dynamic>> futureStandings;

  @override
  void initState() {
    super.initState();
    futureStandings = fetchStandings();
  }

  Future<List<dynamic>> fetchStandings() async {
    final url = Uri.parse("https://api.football-data.org/v4/competitions/$competitionId/standings");
    final response = await http.get(url, headers: {"X-Auth-Token": apiToken});

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // L'API renvoie plusieurs types de classements Général, Domicile et Extérieur
      // index[0] est le classement total
      if (data['standings'] != null && data['standings'].isNotEmpty) {
        return data['standings'][0]['table'];
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
        title: const Text("Classement Ligue 1"),
        backgroundColor: const Color(0xFF14387F),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: futureStandings,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Erreur: ${snapshot.error}", style: const TextStyle(color: Colors.red)));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final table = snapshot.data!;

            return Column(
              children: [
                //en tete
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  color: Colors.grey.shade200,
                  child: const Row(
                    children: [
                      SizedBox(width: 30, child: Text("#", style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(child: Text("Équipe", style: TextStyle(fontWeight: FontWeight.bold))),
                      SizedBox(width: 30, child: Text("J", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                      SizedBox(width: 40, child: Text("Diff", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                      SizedBox(width: 40, child: Text("Pts", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue))),
                    ],
                  ),
                ),

                // liste equipe
                Expanded(
                  child: ListView.builder(
                    itemCount: table.length,
                    itemBuilder: (context, index) {
                      final teamData = table[index];
                      final teamId = teamData['team']['id'];
                      final position = teamData['position'];
                      final teamName = teamData['team']['name'] ?? teamData['team']['name'];
                      final logoUrl = teamData['team']['crest'] ?? "";
                      final playedGames = teamData['playedGames'];
                      final points = teamData['points'];
                      final goalDifference = teamData['goalDifference'];

                      //OL ou pas?
                      final isMyTeam = teamId == myTeamId;

                      return Container(
                        // si ol surbrillance
                        color: isMyTeam ? Colors.red.shade50 : Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: Row(
                          children: [
                            // 1. Position
                            SizedBox(
                                width: 30,
                                child: Text(
                                    position.toString(),
                                    style: TextStyle(
                                        fontWeight: isMyTeam ? FontWeight.bold : FontWeight.normal,
                                        color: isMyTeam ? Colors.red : Colors.black
                                    )
                                )
                            ),

                            // 2. Logo et Nom
                            Expanded(
                              child: Row(
                                children: [
                                  TeamLogo(url: logoUrl, size: 24),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      teamName,
                                      style: TextStyle(
                                          fontWeight: isMyTeam ? FontWeight.bold : FontWeight.normal,
                                          color: isMyTeam ? Colors.red.shade900 : Colors.black
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // 3. match joués
                            SizedBox(
                                width: 30,
                                child: Text(playedGames.toString(), textAlign: TextAlign.center)
                            ),

                            // 4. différence de buts
                            SizedBox(
                                width: 40,
                                child: Text(
                                  goalDifference > 0 ? "+$goalDifference" : goalDifference.toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: goalDifference > 0 ? Colors.green : (goalDifference < 0 ? Colors.red : Colors.grey)),
                                )
                            ),

                            // 5. point
                            SizedBox(
                                width: 40,
                                child: Text(
                                    points.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: isMyTeam ? Colors.red : Colors.blue.shade800
                                    )
                                )
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return const Center(child: Text("Aucun classement disponible."));
        },
      ),
    );
  }
}