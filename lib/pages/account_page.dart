import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:gamedatabaseapp/models/game_model.dart';
import 'package:gamedatabaseapp/pages/login_page.dart';
import 'package:gamedatabaseapp/services/API/api_calls.dart';
import 'package:gamedatabaseapp/services/db_helper.dart';
import 'package:gamedatabaseapp/pages/game_detail_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late Uint8List _imageBytes;
  late String _userId;
  List<String> _favoriteGames = [];

  @override
  void initState() {
    super.initState();
    _imageBytes = Uint8List(0);
    _fetchUserId();
    _fetchFavoriteGames();
  }
  

  Future<void> _fetchUserId() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userId = user.uid;
      });
      await _fetchAndDisplayUserImage();
    } else {
     
      print('User not signed in');
    }
  }

  Future<void> _fetchAndDisplayUserImage() async {
    try {
      final imageBytes = await DBHelper.instance.getUserImage(_userId);
      setState(() {
        _imageBytes = imageBytes;
      });
    } catch (e) {
      print("Error fetching or displaying user image: $e");
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();

    try {
      final pickedFile = await picker.getImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        await DBHelper.instance.insertUserData(_userId, File(pickedFile.path).readAsBytesSync());

        await _fetchAndDisplayUserImage();
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

Future<List<String>> _fetchFavoriteGames() async {
  try {
    final favoriteGames = await DBHelper.instance.getFavoriteGames(_userId);

    favoriteGames.skip(1).toList();

    print('Raw value of favoriteGames: $favoriteGames');

    return favoriteGames;
  } catch (e) {
    print("Error fetching favorite games: $e");
    return [];
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_imageBytes.isNotEmpty)
              Image.memory(_imageBytes, height: 150, width: 150)
            else
              Placeholder(
                fallbackHeight: 150,
                fallbackWidth: 150,
              ),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text("Select profile picture"),
            ),
            Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Text(
                          "Favorite Games list:",
                            style: TextStyle(
                            fontWeight: FontWeight.bold, 
                            fontSize: 20.0),
                        ),
                        )
                      ],
                    ),
                  ]
                ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: FutureBuilder(
              future: _fetchFavoriteGames(),              
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.5,
                    ),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final gameName = snapshot.data![index];
                      
                      return GestureDetector(
                         onTap: () async { 
                          final gameDetails = await GameDetails.fetchGameDetails(gameName);
                          if (gameDetails != null) {
                          final fullGameDetails = await GameDetailsService().fetchGameDetailsById(gameDetails.id);

                           Navigator.push(context,MaterialPageRoute(builder: (context) => GameDetailsPage(game: fullGameDetails)),
                        );
                       }
                     },
                         child: Column(
                            children: [
                              Expanded( 
                                child: Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    FutureBuilder(
                                      future: fetchGameImage(gameName),
                                      builder: (context, imageSnapshot) {
                                        if (imageSnapshot.hasData) {
                                          return Image.network(
                                            imageSnapshot.data!, 
                                            height: 80, 
                                            width: 80, 
                                            fit: BoxFit.cover, 
                                          );
                                        } else if (imageSnapshot.hasError) {
                                          return Icon(Icons.error); 
                                        } else {
                                          return CircularProgressIndicator();
                                        }
                                      },
                                    ),
                                  Positioned(
                                    left: 40,
                                    bottom: 20,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                      ),
                                   onPressed: () async {
                              try {
                                    final userId = FirebaseAuth.instance.currentUser!.uid;
                                    await DBHelper.instance.removeFavoriteGame(userId, gameName); 
                          
                                 setState(() { 
                                });
                                } catch (error) {
                             }
                           },
                           ),
                          ),
                        ],
                      ),
                      ),
                      Expanded(
                        child: Text(gameName.substring(0, 20 > gameName.length ? gameName.length : 20) + '...',
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center, 
                        ),
                        ),
                      ],
                    ),
                  );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error fetching games'));
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          )
      ],
    ),
    )
  );
}
}