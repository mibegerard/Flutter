import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../model/movie.dart';

class ApiService {
  final String _baseUrl = 'https://api.themoviedb.org/3';
  final String _apiKey = dotenv.env['API_KEY'] ?? '';

  Future<dynamic> fetchMovies(String endpoint) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/$endpoint?api_key=$_apiKey'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<List<Movie>> fetchPopularMovies() async {
    final data = await fetchMovies('movie/popular');
    final List movies = data['results'];
    return movies.map((movie) => Movie.fromJson(movie)).toList();
  }

  Future<Movie> fetchMovieById(int id) async {
    final data = await fetchMovies('movie/$id');
    return Movie.fromJson(data);
  }
}