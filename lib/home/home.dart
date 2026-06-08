import 'package:flutter/material.dart';
import '../widgets/next_match_section.dart';
import '../widgets/last_matches_section.dart';
import '../pages/leaderboard.dart';
import '../pages/squad_page.dart';
import '../pages/quizz_page.dart';
import '../pages/videos_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _navigate(Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFFDA0812).withOpacity(0.95),
                     Color(0xFF14387F).withOpacity(0.95)],
            stops: [0.5, 0.5],
          ),
        ),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Column(
              children: [
                const SizedBox(height: 80),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Image.asset("assets/images/icon.png", height: 100),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _NavButton(
                        icon: Icons.play_circle_fill,
                        label: "Vidéos",
                        onTap: () => _navigate(const VideosPage()),
                      ),
                      _NavButton(
                        icon: Icons.group,
                        label: "Effectif",
                        onTap: () => _navigate(const SquadPage()),
                      ),
                      _NavButton(
                        icon: Icons.leaderboard,
                        label: "Classement",
                        onTap: () => _navigate(const LeaderboardPage()),
                      ),
                      _NavButton(
                        icon: Icons.quiz,
                        label: "Quiz",
                        onTap: () => _navigate(const QuizPage()),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const NextMatchSection(),
                const Divider(height: 40, color: Colors.white24),
                const LastMatchesSection(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _NavButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.4),
                width: 1.5,
              ),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}