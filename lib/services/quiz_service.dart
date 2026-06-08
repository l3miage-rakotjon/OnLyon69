import '../models/quiz_question.dart';

class QuizService {
  List<QuizQuestion> getOlQuestions() {
    return [
      QuizQuestion(
        "Quel est le surnom couramment donné aux joueurs de l'Olympique Lyonnais ?",
        ["Les Dogues", "Les Gones", "Les Canaris", "Les Lionceaux"],
        1,
      ),
      QuizQuestion(
        "Quel est l'ancien nom de la ville de Lyon",
        ["Lyonnus", "Laragnums", "Lugdunum", "La ville n'a jamais changé de nom"],
        2,
      ),
      QuizQuestion(
        "Dans quel stade l'OL joue-t-il ses matchs à domicile lors de la saison 2025/2026 ?",
        ["Stade de Gerland", "Groupama Stadium", "Stade de la Mosson", "Allianz Riviera"],
        1,
      ),
      QuizQuestion(
        "Qui est l'entraîneur de l'OL pour cette saison 2025-2026 ?",
        ["Fabio Grosso", "Pierre Sage", "Paulo Fonseca", "Bruno Génésio"],
        2,
      ),
      QuizQuestion(
        "Combien de titres de champion de France consécutifs l'OL a-t-il remportés entre 2002 et 2008 ?",
        ["5", "6", "7", "8"],
        2,
      ),
      QuizQuestion(
        "Quel attaquant géorgien a fait son retour au club lors du mercato d'été 2024 avant de repartir pour sauver les finances du club ?",
        ["Khvicha Kvaratskhelia", "Geroges Mikautadze", "Zuriko Davitashvili", "Saba Lobjanidze"],
        1,
      ),
      QuizQuestion(
        "Quel défenseur central a été recruté à Nottingham Forest à l'été 2024 pour un montant record (environ 30M€) ?",
        ["Duje Caleta-Car", "Moussa Niakhaté", "Jake O'Brien", "Clinton Mata"],
        1,
      ),
      QuizQuestion(
        "En 2020, l'OL a atteint la demi-finale de la Ligue des Champions. Quel club les a éliminés ?",
        ["Manchester City", "Juventus", "Bayern Munich", "PSG"],
        2,
      ),
      QuizQuestion(
        "Qui détient le record du nombre de matchs disputés sous le maillot de l'OL (541 matchs) ?",
        ["Grégory Coupet", "Anthony Lopes", "Serge Chiesa", "Fleury Di Nallo"],
        2,
      ),
      QuizQuestion(
        "Contre quelle équipe l'OL a-t-il validé sa qualification miraculeuse en Coupe d'Europe lors de la dernière journée de la saison 2023-2024 ?",
        ["Lille", "Nice", "Monaco", "Strasbourg"],
        3,
      )
    ];
  }
}