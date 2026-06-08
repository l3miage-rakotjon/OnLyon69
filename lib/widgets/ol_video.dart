import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class OlVideosWidget extends StatefulWidget {
  const OlVideosWidget({super.key});

  @override
  State<OlVideosWidget> createState() => _OlVideosWidgetState();
}

class _OlVideosWidgetState extends State<OlVideosWidget> {
  List<Map<String, dynamic>> _videos = [];
  bool _isLoading = true;
  String? _errorMessage;

  static const String _apiKey = 'AIzaSyDL8hhg87DLsSp4Tc7ujRn1iZ6aA5g_xEE';

  @override
  void initState() {
    super.initState();
    _fetchVideos();
  }

  Future<void> _fetchVideos() async {
    try {
      final channelUrl = Uri.parse(
        'https://www.googleapis.com/youtube/v3/channels'
            '?part=contentDetails'
            '&forHandle=OlympiqueLyonnais'
            '&key=$_apiKey',
      );

      final channelResponse = await http.get(channelUrl);

      if (channelResponse.statusCode != 200) {
        throw Exception('Erreur channel HTTP ${channelResponse.statusCode}');
      }

      final channelData = json.decode(channelResponse.body);
      final items = channelData['items'] as List<dynamic>?;

      if (items == null || items.isEmpty) {
        throw Exception('Chaîne introuvable');
      }

      final uploadsPlaylistId =
      items[0]['contentDetails']['relatedPlaylists']['uploads'];

      final videosUrl = Uri.parse(
        'https://www.googleapis.com/youtube/v3/playlistItems'
            '?part=snippet'
            '&playlistId=$uploadsPlaylistId'
            '&maxResults=10'
            '&key=$_apiKey',
      );

      final videosResponse = await http.get(videosUrl);

      if (videosResponse.statusCode != 200) {
        throw Exception('Erreur vidéos HTTP ${videosResponse.statusCode}');
      }

      final videosData = json.decode(videosResponse.body);
      final videoItems = videosData['items'] as List<dynamic>;

      if (mounted) {
        setState(() {
          _videos = videoItems.map((item) {
            final snippet = item['snippet'];
            final videoId = snippet['resourceId']['videoId'];
            final thumbnails = snippet['thumbnails'] as Map<String, dynamic>;
            final thumbnail = (thumbnails['maxres'] ??
                thumbnails['high'] ??
                thumbnails['medium'] ??
                thumbnails['default'])['url'] as String;
            return {
              'title': snippet['title'] as String,
              'thumbnail': thumbnail,
              'url': 'https://www.youtube.com/watch?v=$videoId',
            };
          }).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Erreur : $e';
        });
      }
      debugPrint('Erreur fetch vidéos OL: $e');
    }
  }

  Future<void> _openVideo(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Impossible d\'ouvrir $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            Text(_errorMessage!, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _errorMessage = null;
                });
                _fetchVideos();
              },
              child: const Text('Réessayer'),
            ),
          ],
        ),
      );
    }

    if (_videos.isEmpty) {
      return const Center(child: Text('Aucune vidéo trouvée.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _videos.length,
      itemBuilder: (context, index) {
        final video = _videos[index];
        return GestureDetector(
          onTap: () => _openVideo(video['url']),
          child: Card(
            margin: const EdgeInsets.only(bottom: 20.0),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  video['thumbnail'],
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 220,
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, size: 50),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    video['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}