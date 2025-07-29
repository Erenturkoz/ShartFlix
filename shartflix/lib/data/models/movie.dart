class Movie {
  final String id;
  final String title;
  final String description;
  final String posterUrl;
  bool isFavorite;

  Movie({
    required this.id,
    required this.title,
    required this.description,
    required this.posterUrl,
    this.isFavorite = false,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    final images = json['Images'] as List<dynamic>?;
    final rawPoster = json['Poster'] ?? '';
    final securePoster = rawPoster.replaceFirst('http://', 'https://');
    return Movie(
      id: json['id'] ?? json['_id'],
      title: json['Title'],
      description: json['Plot'],
      posterUrl: securePoster,

      // posterUrl: images != null && images.isNotEmpty ? images[0] as String : '',
    );
  }
}
