import 'package:flutter/material.dart';
import '../widgets/next_match_section.dart';
import '../widgets/last_matches_section.dart';
import '../pages/leaderboard.dart';
import '../pages/squad_page.dart';
import '../pages/quizz_page.dart';
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
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SquadPage()),
              );
            },
            icon: const Icon(Icons.group),
            tooltip: "Effectif",
          ),
          IconButton(onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const LeaderboardPage()),
            );
          }, icon: const Icon(Icons.leaderboard)),
          IconButton(onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const QuizPage()),);
          },
          icon: const Icon(Icons.quiz),)
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

            const NextMatchSection(),

            const Divider(height: 40),

            const LastMatchesSection(),

            const SizedBox(height: 20),
          ],
        ),
      ),
    ),);
  }
}