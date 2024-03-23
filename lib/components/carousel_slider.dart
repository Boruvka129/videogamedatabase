import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:gamedatabaseapp/models/game_model.dart';
import 'package:gamedatabaseapp/services/API/api_calls.dart';
import 'package:gamedatabaseapp/pages/game_detail_page.dart';
import 'package:cached_network_image/cached_network_image.dart';


class PopularGamesCarousel extends StatefulWidget {
  @override
  _PopularGamesCarouselState createState() => _PopularGamesCarouselState();
}

class _PopularGamesCarouselState extends State<PopularGamesCarousel> {
  late Future<List<Game>> popularGameDataList;

  @override
  void initState() {
    super.initState();
    popularGameDataList = PopularGamesLast30Days.fetchPopularGamesLast30Days();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 60.0),
        child: FutureBuilder<List<Game>>(
          future: popularGameDataList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError || snapshot.data == null) {
                return Center(child: Text('Error loading popular games'));
              } else {
                return CarouselSlider.builder(
                  itemCount: snapshot.data!.length ?? 0,
                  options: CarouselOptions(
                    aspectRatio: 16 / 9,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: true,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    scrollDirection: Axis.horizontal,
                  ),
                 itemBuilder: (BuildContext context, int index, int realIndex) {
                    return GestureDetector(
                      onTap: () async {
                        final details = await GameDetailsService()
                            .fetchGameDetailsById(snapshot.data![index].id);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GameDetailsPage(game: details),
                          ),
                        );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 2.0),
                        child: Column(
                          children: [
                            CachedNetworkImage(
                            imageUrl: snapshot.data![index].backgroundImage,
                            width: 300.0,
                            height: 150.0,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => CircularProgressIndicator(),
                            errorWidget: (context, url, error) => Icon(Icons.error), 
                          ),
                            SizedBox(height: 10.0),
                            Text(
                              snapshot.data![index].name,
                              style: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}