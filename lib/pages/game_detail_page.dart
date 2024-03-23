import 'package:flutter/material.dart';
import 'package:gamedatabaseapp/models/game_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gamedatabaseapp/services/db_helper.dart';
import 'package:google_fonts/google_fonts.dart';


class GameDetailsPage extends StatefulWidget {
  final Game game;

  const GameDetailsPage({Key? key, required this.game}) : super(key: key);

  @override
  _GameDetailsPageState createState() => _GameDetailsPageState();
}

class _GameDetailsPageState extends State<GameDetailsPage> {
  bool isFavorite = false;
  bool _isExpanded = false; 

  @override
  void initState() {
    super.initState();
    _checkIsFavorite();
  }

Future<void> _checkIsFavorite() async {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final favoriteGames = await DBHelper.instance.getFavoriteGames(userId);


  isFavorite = favoriteGames.contains(widget.game.name) || false; 

  setState(() {});
}

  Future<void> _toggleFavorite() async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      if (isFavorite) {
        await DBHelper.instance.removeFavoriteGame(userId, widget.game.name);
      } else {
        await DBHelper.instance.addFavoriteGame(userId, widget.game.name);
      }
      setState(() {
        isFavorite = !isFavorite;
      });
    } catch (error) {
      
    }
  }

  String truncateString(String text, int length) {
    return (text.length > length) ? text.substring(0, length) + '...' : text;
  }

  @override
  Widget build(BuildContext context) {
    bool _isExpanded = false;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.game.name),
      ),
      body: SingleChildScrollView(
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.network(
            widget.game.backgroundImage,
            fit: BoxFit.cover,
            height: 200.0,
          ),
          SizedBox(height: 16.0),
          Align(
          alignment: Alignment.centerLeft, 
          child: Text('${widget.game.name}', 
            style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
        ),
      ),
    ),
          Align(
          alignment: Alignment.centerLeft, 
          child: Text('${widget.game.released}', 
            style: TextStyle(
            fontWeight: FontWeight.bold,
        ),
      ),
    ),
          Align(
          alignment: Alignment.centerLeft, 
          child: Text('Rating: ${widget.game.rating} / 5', 
            style: TextStyle(
            fontWeight: FontWeight.bold,
        ),
      ),
    ),
          Text('${widget.game.description}',
          style: GoogleFonts.poppins(),),
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.black,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      )
      
    );
  }
}
