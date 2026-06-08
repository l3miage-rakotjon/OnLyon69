import 'package:flutter/material.dart';
import '../models/quiz_question.dart';
import '../services/quiz_service.dart';
import '../widgets/question.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final QuizService _quizService = QuizService();
  late List<QuizQuestion> olQuestions;

  int currentQuestionIndex = 0;
  int score = 0;
  bool isFinished = false;
  bool isAnswered = false;
  int? selectedAnswerIndex;

  @override
  void initState() {
    super.initState();
    olQuestions = _quizService.getOlQuestions();
  }

  void checkAnswer(int selectedIndex) {
    if (isAnswered) return;

    setState(() {
      isAnswered = true;
      selectedAnswerIndex = selectedIndex;

      if (selectedIndex == olQuestions[currentQuestionIndex].correctAnswerIndex) {
        score++;
      }
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;

      setState(() {
        if (currentQuestionIndex < olQuestions.length - 1) {
          currentQuestionIndex++;
        } else {
          isFinished = true;
        }
        isAnswered = false;
        selectedAnswerIndex = null;
      });
    });
  }

  void restartQuiz() {
    setState(() {
      currentQuestionIndex = 0;
      score = 0;
      isFinished = false;
      isAnswered = false;
      selectedAnswerIndex = null;
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
        isAnswered: isAnswered,
        selectedAnswerIndex: selectedAnswerIndex,
        correctAnswerIndex: currentQuestion.correctAnswerIndex,
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