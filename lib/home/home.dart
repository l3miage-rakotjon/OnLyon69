import 'package:flutter/material.dart';
import 'package:onlyon69/models/user.dart';
import '../pages/profilepage.dart';
import '../widgets/next_match_section.dart';
import '../widgets/last_matches_section.dart';

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
        title: const Text("Accueil"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProfilePage(user: User("Jo", "Jo", "")),
                ));
              },
              icon: const Icon(Icons.person)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Image.asset("assets/images/icon.jpg", height: 100)),
            ),
            const Text("Bienvenue sur la page d'accueil", style: TextStyle(fontSize: 20.0)),
            const Divider(height: 40),

            // 1. Le composant du prochain match
            const NextMatchSection(),

            const Divider(height: 40),

            // 2. Le composant des derniers résultats
            const LastMatchesSection(),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}