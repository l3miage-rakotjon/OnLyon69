import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TeamLogo extends StatelessWidget {
  final String url;
  final double size;
  
  const TeamLogo({super.key, required this.url, this.size = 40.0});

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) {
      return Icon(Icons.shield, size: size, color: Colors.grey);
    }

    if (url.endsWith('.svg')) {
      return SvgPicture.network(
        url,
        height: size,
        width: size,
        placeholderBuilder: (context) => SizedBox(
            height: size,
            width: size,
            child: const CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    return Image.network(
      url,
      height: size,
      width: size,
      errorBuilder: (context, error, stackTrace) =>
          Icon(Icons.shield, size: size, color: Colors.grey),
    );
  }
}