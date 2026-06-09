# OnLyon69 - L'application des Gones

**OnLyon69** est une application mobile développée avec Flutter, elle permet de suivre les derniers résultats, les dernières actualités mais aussi de préparer votre venue au sein de votre club de coeur : l'Olympique Lyonnais 🔴🔵

## Fonctionnalités Principales

* **Matchs & Résultats :** Affichage du prochain match de l'OL avec un lien direct vers la billetterie officielle, ainsi que l'historique des 5 derniers matchs.
* **Classement Ligue 1 :** Suivi en temps réel du classement général de la Ligue 1, avec l'ajout des logos et un visuel agréable. L'Olympique Lyonnais est mis en surbrillance permettant de voir en un coup d'oeil où en est notre équipe.
* **Effectif & Joueurs :** Liste complète des joueurs de la saison en cours (avec l'ajout de vignettes pour savoir leurs postes), avec des fiches détaillées (date de naissance, numéro, nationalité, détails du contrat).
* **Vidéos :** Intégration des 10 dernières vidéos de la chaîne YouTube officielle de l'Olympique Lyonnais pour ne rien manquer de l'actualité du club.
* **Quiz OL :** Un mini-jeu interactif de 10 questions pour tester ses connaissances sur l'histoire et les joueurs du club, de nouveaux quizzs arrivent bientôt.

---

## Problèmes rencontrés

Une gestion des erreurs causées par l'API dû à l'intersaison a eu lieu avec l'affichage d'une erreur plus compréhensible.
Malheureusement, il est donc à l'heure actuelle à cause des problèmes liés à l'API impossible de consulter les 5 derniers matchs, le prochain match et l'effectif.
Une solution était de récupérer les données de la saison précédente si celles de la saison courante ne sont pas disponibles, mais cette option nécessite de souscrire à la version payante de l'API. Ces fonctionnalités sont visibles sur la démo que nous avons faite.
N'hésitez pas à relancer l'application au début de la saison prochaine pour avoir accès à toutes nos fonctionnalités !

## Stack Technique & Bibliothèques

Ce projet est construit avec le SDK **Flutter** (Dart) et utilise les packages suivants :

* **[`http`](https://pub.dev/packages/http) :** Pour les requêtes REST vers les API externes.
* **[`flutter_svg`](https://pub.dev/packages/flutter_svg) :** Pour l'affichage vectoriel des logos des clubs de football.
* **[`url_launcher`](https://pub.dev/packages/url_launcher) :** Pour l'ouverture de liens externes (Billetterie OL, application YouTube).

**APIs utilisées :**
* [Football-Data API](https://www.football-data.org/) (Classement, Matchs, Effectif).
* [YouTube Data API v3](https://developers.google.com/youtube/v3) (Récupération des vidéos de la chaîne OL).

## 📂 Structure du Projet

L'architecture du code est organisée de manière modulaire dans le dossier `lib/` :

```text
lib/
 ┣ models/           # Modèles de données (User, QuizQuestion)
 ┣ pages/            # Écrans principaux (Leaderboard, Squad, PlayerDetails, Quiz, Videos...)
 ┣ services/         # Logique métier et données statiques (QuizService,translation_service)
 ┣ widgets/          # Composants UI réutilisables (TeamLogo, QuestionWidget, Sections Matchs...)
 ┣ home/             # Écran d'accueil (HomePage)
 ┗ main.dart         # Point d'entrée de l'application
```

## 🚀 Guide d'Installation

### 1. Prérequis

* Avoir installé le [SDK Flutter](https://docs.flutter.dev/get-started/install) (version >= 3.10.8).
* Avoir un émulateur ou un appareil physique Android configuré.

### 2. Extraire le fichier ZIP

Extrayez le fichier ZIP dans le répertoire souhaité

### 3. Installer les dépendances

```bash
flutter pub get

```

### 4. Lancer l'application

```bash
flutter run 

```
Possible aussi d'exécuter le main
---

## 🤝 Contribution

Notre projet est également présent sur Github :
https://github.com/l3miage-rakotjon/OnLyon69.git

Si en tant que fan de l'OL vous souhaitez contribuer afin de sortir cette appli sur le store !

1. Forkez le projet.
2. Créez une branche pour votre fonctionnalité (`git checkout -b feature/NouvelleFonctionnalite`).
3. Commitez vos changements (`git commit -m 'Ajout d'une nouvelle fonctionnalité'`).
4. Pushez vers la branche (`git push origin feature/NouvelleFonctionnalite`).
5. Ouvrez une Pull Request.

---
A la saison prochaine et n'oubliez pas : 
**Allez l'OL ! 🔴🔵**

**Joran MONNERON 🔴🔵**
**Jonathan RAKOTOMALALA 🔴🔵**



 