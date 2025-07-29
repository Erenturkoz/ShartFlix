import 'package:flutter/material.dart';
import 'package:shartflix/data/models/movie.dart';

class FavoriteMovieCard extends StatelessWidget {
  final Movie movie;

  const FavoriteMovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Film görseli
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              movie.posterUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) =>
                  const SizedBox.shrink(),
            ),
          ),
        ),
        const SizedBox(height: 6),
        // Başlık
        Text(
          movie.title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        // Alt açıklama
        Text(
          movie.description,
          style: const TextStyle(fontSize: 12, color: Colors.white60),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
