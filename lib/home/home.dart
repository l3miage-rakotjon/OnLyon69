import 'package:flutter/material.dart';
import '../widgets/next_match_section.dart';
import '../widgets/last_matches_section.dart';
import '../pages/leaderboard.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        actions: [
          IconButton(onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const LeaderboardPage()),
            );
          }, icon: const Icon(Icons.leaderboard)),
        ],
      ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,


              colors: [
                Color(0xFFDA0812),
                Color(0xFF14387F),
              ],


              stops: [0.5, 0.5],
            ),
          ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Image.asset("assets/images/icon.png", height: 100)),
            ),

            // 1. Le composant du prochain match
            const NextMatchSection(),

            const Divider(height: 40),

            // 2. Le composant des derniers résultats
            const LastMatchesSection(),

            const SizedBox(height: 20),
          ],
        ),
      ),
    ),);
  }
}