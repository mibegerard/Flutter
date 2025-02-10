class Movie {
  final int id;
  final String title;
  final String posterPath;
  final String releaseDate;
  final int runtime;

  Movie({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.releaseDate,
    required this.runtime,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      posterPath: json['poster_path'],
      releaseDate: json['release_date'],
      runtime: json['runtime'] ?? 0,
    );
  }
}