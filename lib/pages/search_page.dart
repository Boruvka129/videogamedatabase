import 'package:flutter/material.dart';
import 'package:gamedatabaseapp/pages/categories/rpg_games_page.dart';
import 'package:provider/provider.dart';
import 'package:gamedatabaseapp/models/game_model.dart';
import 'package:gamedatabaseapp/services/API/api_calls.dart';
import 'package:gamedatabaseapp/pages/game_detail_page.dart';
import 'package:gamedatabaseapp/pages/categories/shooter_games_page.dart';
import 'package:gamedatabaseapp/pages/categories/adventure_games_page.dart';
import 'package:gamedatabaseapp/pages/categories/puzzle_games_page.dart';
import 'package:gamedatabaseapp/pages/categories/simulation_game_page.dart';
import 'package:gamedatabaseapp/pages/categories/racing_game_page.dart';


class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Game> _searchResults = [];
  bool showSearchResults = false;

  Future<void> _searchGames(String query) async {
    try {
      final games = await APISearch.searchGames(query);
      setState(() {
        _searchResults = games;
        showSearchResults = true; 
      });
    } catch (e) {
      print('Search Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search for a game...',
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              final query = _searchController.text;
              if (query.isNotEmpty) {
                await _searchGames(query);
              }
            },
          ),
        ],
      ),
      body: showSearchResults
          ? ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final game = _searchResults[index];
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
                  child: ListTile(
                    title: Text(game.name),
                    subtitle: Text('Released on: ${game.released}'),
                  ),
                );
              },
            )
          : Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      GestureDetector(
                        onTap: (){
                        Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PopularShooterGamesPage())
                        );
                        },
                    child:Container(
                        margin: EdgeInsets.all(8.0),
                        padding: EdgeInsets.all(16.0),
                        width: MediaQuery.of(context).size.width / 2 - 16.0,
                        decoration: BoxDecoration(
                    image: DecorationImage(
                    image: AssetImage("lib/images/shooter.jpg"), 
                      fit: BoxFit.cover, 
                    ),
                  ),
                        child: Stack(
                        children: [
                              Center( 
                                child: Text('Shooter',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                        Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PopularRPGGamesPage())
                        );
                        },
                   child:Container(
                        margin: EdgeInsets.all(8.0),
                        padding: EdgeInsets.all(16.0),
                        width: MediaQuery.of(context).size.width / 2 - 16.0,
                        decoration: BoxDecoration(
                    image: DecorationImage(
                    image: AssetImage("lib/images/rpg.jpg"), 
                      fit: BoxFit.cover, 
                    ),
                  ),
                        child: Stack(
                        children: [
                              Center( 
                                child: Text('RPG',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ]
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      GestureDetector(
                        onTap: (){
                        Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PopularAdventureGamesPage())
                        );
                        },
                    child:Container(
                        margin: EdgeInsets.all(8.0),
                        padding: EdgeInsets.all(16.0),
                        width: MediaQuery.of(context).size.width / 2 - 16.0,
                        decoration: BoxDecoration(
                    image: DecorationImage(
                    image: AssetImage("lib/images/adventure.jpg"), 
                      fit: BoxFit.cover, 
                    ),
                  ),
                        child: Stack(
                        children: [
                              Center( 
                                child: Text('Adventure',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                        Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PopularPuzzleGamesPage())
                        );
                        },
                    child:Container(
                        margin: EdgeInsets.all(8.0),
                        padding: EdgeInsets.all(16.0),
                        width: MediaQuery.of(context).size.width / 2 - 16.0,
                        decoration: BoxDecoration(
                    image: DecorationImage(
                    image: AssetImage("lib/images/puzzle.jpg"), 
                      fit: BoxFit.cover, 
                    ),
                  ),
                        child: Stack(
                        children: [
                              Center( 
                                child: Text('Puzzle',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ]
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      GestureDetector(
                        onTap: (){
                        Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PopularSimulationGamesPage())
                        );
                        },
                    child:Container(
                        margin: EdgeInsets.all(8.0),
                        padding: EdgeInsets.all(16.0),
                        width: MediaQuery.of(context).size.width / 2 - 16.0,
                        decoration: BoxDecoration(
                    image: DecorationImage(
                    image: AssetImage("lib/images/simulation.jpg"), 
                      fit: BoxFit.cover, 
                    ),
                  ),
                        child: Stack(
                        children: [
                              Center( 
                                child: Text('Simulation',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                        Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PopularRacingGamesPage())
                        );
                        },
                    child:Container(
                        margin: EdgeInsets.all(8.0),
                        padding: EdgeInsets.all(16.0),
                        width: MediaQuery.of(context).size.width / 2 - 16.0,
                        decoration: BoxDecoration(
                    image: DecorationImage(
                    image: AssetImage("lib/images/racing.jpg"), 
                      fit: BoxFit.cover, 
                    ),
                  ),
                        child: Stack(
                        children: [
                              Center( 
                                child: Text('Racing',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ]
                    ),
                  ]
          )
    );
  }
}