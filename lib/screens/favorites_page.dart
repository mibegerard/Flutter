import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/movie.dart';
import '../service/api_service.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Movie> _favoriteMovies = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteMovies();
  }

  void _loadFavoriteMovies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favoriteMovieIds = prefs.getStringList('favoriteMovies');
    if (favoriteMovieIds != null) {
      List<Movie> favoriteMovies = [];
      for (String id in favoriteMovieIds) {
        final movie = await ApiService().fetchMovieById(int.parse(id));
        favoriteMovies.add(movie);
      }
      setState(() {
        _favoriteMovies = favoriteMovies;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Films Favoris'),
      ),
      body: _favoriteMovies.isEmpty
          ? Center(child: Text('Aucun film favori'))
          : ListView.builder(
              itemCount: _favoriteMovies.length,
              itemBuilder: (context, index) {
                final movie = _favoriteMovies[index];
                return ListTile(
                  leading: Image.network(
                    'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(movie.title),
                  subtitle: Text('${movie.releaseDate} • ${movie.runtime} min'),
                );
              },
            ),
    );
  }
}