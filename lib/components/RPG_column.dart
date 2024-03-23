import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gamedatabaseapp/services/API/api_key.dart';
import 'package:gamedatabaseapp/models/game_model.dart';
import 'package:gamedatabaseapp/services/API/api_calls.dart';
import 'package:gamedatabaseapp/pages/game_detail_page.dart';
import 'package:cached_network_image/cached_network_image.dart';


class RPGColumn extends StatefulWidget {
  @override
  _RPGColumnState createState() => _RPGColumnState();
}

class _RPGColumnState extends State<RPGColumn> {
  late Future<List<Game>> games;

  @override
  void initState() {
    super.initState();
    games = PopularRPGGames.fetchPopularRPGGames();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: FractionalOffset.centerLeft,
      child: Container(
        width: MediaQuery.of(context).size.width / 2, 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Most popular RPG games',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            FutureBuilder<List<Game>>(
              future: games,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.data == null) {
                  return Text('No data available');
                } else {
                  List<Game> gameList = snapshot.data!;
                  return Column(
                      children: [
                        for (Game game in gameList)
                          GestureDetector(
                            onTap: () async {
                              final details = await GameDetailsService().fetchGameDetailsById(game.id);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      GameDetailsPage(game: details),
                                ),
                              );
                            },
                            child: Card(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 80.0,
                                    height: 80.0,
                                    child: CachedNetworkImage(
                                      imageUrl: game.backgroundImage,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => CircularProgressIndicator(),
                                      errorWidget: (context, url, error) => Icon(Icons.error), 
                                   ),
                                  ),
                                  SizedBox(width: 16.0),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('${game.name}'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    );
                  
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}