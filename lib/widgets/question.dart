import 'package:flutter/material.dart';

class QuestionWidget extends StatelessWidget {
  final String question;
  final List<String> options;
  final int currentIndex;
  final int totalQuestions;
  final Function(int) onAnswerSelected;

  final bool isAnswered;
  final int? selectedAnswerIndex;
  final int correctAnswerIndex;

  const QuestionWidget({
    super.key,
    required this.question,
    required this.options,
    required this.currentIndex,
    required this.totalQuestions,
    required this.onAnswerSelected,
    required this.isAnswered,
    required this.selectedAnswerIndex,
    required this.correctAnswerIndex,
  });

  Color getButtonBackgroundColor(int optionIndex) {
    if (!isAnswered) {
      return Colors.red.shade50;
    }
    if (optionIndex == correctAnswerIndex) {
      return Colors.green;
    }
    if (optionIndex == selectedAnswerIndex) {
      return Colors.red;
    }
    return Colors.grey.shade300;
  }

  Color getButtonTextColor(int optionIndex) {
    if (!isAnswered) {
      return Colors.red.shade900;
    }
    if (optionIndex == correctAnswerIndex || optionIndex == selectedAnswerIndex) {
      return Colors.white;
    }
    return Colors.grey.shade600;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Question ${currentIndex + 1}/$totalQuestions",
          style: const TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 30),

        Text(
          question,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),

        ...List.generate(options.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                backgroundColor: getButtonBackgroundColor(index),
                foregroundColor: getButtonTextColor(index),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => onAnswerSelected(index),
              child: Text(
                options[index],
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }),
      ],
    );
  }
}