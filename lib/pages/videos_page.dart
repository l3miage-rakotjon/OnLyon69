import 'package:flutter/material.dart';
import '../widgets/ol_video.dart';

class VideosPage extends StatelessWidget {
  const VideosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dernières Vidéos"),
        backgroundColor: const Color(0xFF14387F),
        foregroundColor: Colors.white,
      ),
      body: const OlVideosWidget(),
    );
  }
}