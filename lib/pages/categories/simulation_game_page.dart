import 'package:flutter/material.dart';
import 'package:gamedatabaseapp/models/game_model.dart';
import 'package:gamedatabaseapp/services/API/api_calls.dart'; 
import 'package:gamedatabaseapp/pages/game_detail_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gamedatabaseapp/services/db_helper.dart';

class PopularSimulationGamesPage extends StatefulWidget {
  @override
  _PopularSimulationGamesPageState createState() => _PopularSimulationGamesPageState();
}

class _PopularSimulationGamesPageState extends State<PopularSimulationGamesPage> {
  Future<List<Game>> _futureGames = PopularSimulationGames.fetchPopularSimulationGames();

  final Set<String> _favorites = {}; 

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    if (FirebaseAuth.instance.currentUser != null) {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final favoriteGames = await DBHelper.instance.getFavoriteGames(userId);
      setState(() {
        _favorites.addAll(favoriteGames);
      });
    }
  }

  Future<List<Game>> _fetchGamesWithFavorites() async {
    return PopularPuzzleGames.fetchPopularPuzzleGames();
  }

  Future<void> _toggleFavorite(Game game) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    if (_favorites.contains(game.name)) {
      await DBHelper.instance.removeFavoriteGame(userId, game.name);
      setState(() {
        _favorites.remove(game.name);
      });
    } else {
      await DBHelper.instance.addFavoriteGame(userId, game.name);
      setState(() {
        _favorites.add(game.name);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Simulation Games'),
      ),
      body: FutureBuilder<List<Game>>(
        future: _futureGames,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final game = snapshot.data![index];
                return GestureDetector(
                  onTap: () async {
                  final details = await GameDetailsService().fetchGameDetailsById(game.id);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GameDetailsPage(game: details),
                      ),
                    );
                  },
                  child: Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.network(
                          game.backgroundImage ?? 'https://via.placeholder.com/300',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 100,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            game.name,
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            _favorites.contains(game.name) ? Icons.favorite : Icons.favorite_border,
                            color: _favorites.contains(game.name) ? Colors.red : Colors.grey,
                          ),
                          onPressed: () => _toggleFavorite(game),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}