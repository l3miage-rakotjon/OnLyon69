import 'package:flutter/material.dart';
import '../widgets/question.dart';


class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;

  QuizQuestion(this.question, this.options, this.correctAnswerIndex);
}

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int currentQuestionIndex = 0;
  int score = 0;
  bool isFinished = false;


  final List<QuizQuestion> olQuestions = [
    QuizQuestion(
      "Quel est le surnom couramment donné aux joueurs de l'Olympique Lyonnais ?",
      [ "Les Dogues", "Les Gones", "Les Canaris", "Les Lionceaux"],
      1,
    ),
    QuizQuestion(
      "Quel joueur, revenu au club en 2022, est l'actuel capitaine et leader de l'attaque ?",
      ["Corentin Tolisso","Anthony Lopes","Alexandre Lacazette", "Maxence Caqueret"],
      2,
    ),
    QuizQuestion(
      "Dans quel stade l'OL joue-t-il ses matchs à domicile cette saison ?",
      ["Stade de Gerland", "Groupama Stadium", "Stade de la Mosson", "Allianz Riviera"],
      1,
    ),
    QuizQuestion(
      "Qui est l'entraîneur de l'OL pour cette saison 2024-2025 ?",
      ["Fabio Grosso", "Lauren Blanc", "Pierre Sage", "Bruno Génésio"],
      2,
    ),
    QuizQuestion("Combien de titres de champion de France consécutifs l'OL a-t-il remportés entre 2002 et 2008 ?",
  ["5","6","7","8"],
   2),
    QuizQuestion("Quel attaquant géorgien a fait son retour au club lors du mercato d'été 2024 ?",
        ["Khvicha Kvaratskhelia","Geroges Mikautadze","Zuriko Davitashvili","Saba Lobjanidze"],
   1),
    QuizQuestion("Quel défenseur central a été recruté à Nottingham Forest à l'été 2024 pour un montant record (environ 30M€) ?",
        ["Duje Caleta-Car","Moussa Niakhaté","Jake O'Brien","Clinton Mata"],
        1),
    QuizQuestion("En 2020, l'OL a atteint la demi-finale de la Ligue des Champions. Quel club les a éliminés ?",
        ["Manchester City","Juventus","Bayern Munich","PSG"],
        2),
    QuizQuestion("Qui détient le record du nombre de matchs disputés sous le maillot de l'OL (541 matchs) ?",
        ["Grégory Coupet","Anthony Lopes","Serge Chiesa","Fleury Di Nallo"],
        2),
    QuizQuestion("Contre quelle équipe l'OL a-t-il validé sa qualification miraculeuse en Coupe d'Europe lors de la dernière journée de la saison 2023-2024 ?",
        ["Lille","Nice","Monaco","Strasbourg"],
        3)
  ];

  void checkAnswer(int selectedIndex) {

    if (selectedIndex == olQuestions[currentQuestionIndex].correctAnswerIndex) {
      score++;
    }

    setState(() {
      if (currentQuestionIndex < olQuestions.length - 1) {
        currentQuestionIndex++;
      } else {
        isFinished = true;
      }
    });
  }


  void restartQuiz() {
    setState(() {
      currentQuestionIndex = 0;
      score = 0;
      isFinished = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiz OL"),
        backgroundColor: const Color(0xFF14387F),
        foregroundColor: Colors.white,
      ),

      body: isFinished ? _buildResultScreen() : _buildQuizScreen(),
    );
  }


  Widget _buildQuizScreen() {
    final currentQuestion = olQuestions[currentQuestionIndex];

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: QuestionWidget(
        question: currentQuestion.question,
        options: currentQuestion.options,
        currentIndex: currentQuestionIndex,
        totalQuestions: olQuestions.length,

        onAnswerSelected: checkAnswer,
      ),
    );
  }


  Widget _buildResultScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.emoji_events, size: 80, color: Colors.amber),
          const SizedBox(height: 20),
          const Text("Quiz terminé !", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text(
            "Votre score : $score / ${olQuestions.length}",
            style: const TextStyle(fontSize: 22, color: Colors.red, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40),
          ElevatedButton.icon(
            onPressed: restartQuiz,
            icon: const Icon(Icons.refresh),
            label: const Text("Rejouer"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF14387F),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
          )
        ],
      ),
    );
  }
}