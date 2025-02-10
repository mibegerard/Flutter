import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../service/api_service.dart';
import '../model/movie.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Movie>> _popularMovies;
  List<int> _favoriteMovieIds = [];

  @override
  void initState() {
    super.initState();
    _popularMovies = ApiService().fetchPopularMovies();
    _loadFavorites();
  }

  void _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _favoriteMovieIds = prefs.getStringList('favoriteMovies')?.map((id) => int.parse(id)).toList() ?? [];
    });
  }

  void _toggleFavorite(int movieId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (_favoriteMovieIds.contains(movieId)) {
        _favoriteMovieIds.remove(movieId);
      } else {
        _favoriteMovieIds.add(movieId);
      }
      prefs.setStringList('favoriteMovies', _favoriteMovieIds.map((id) => id.toString()).toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accueil'),
      ),
      body: FutureBuilder<List<Movie>>(
        future: _popularMovies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucun film trouvé'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final movie = snapshot.data![index];
                final isFavorite = _favoriteMovieIds.contains(movie.id);
                return ListTile(
                  leading: Image.network(
                    'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(movie.title),
                  subtitle: Text('${movie.releaseDate} • ${movie.runtime} min'),
                  trailing: IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : null,
                    ),
                    onPressed: () {
                      _toggleFavorite(movie.id);
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}