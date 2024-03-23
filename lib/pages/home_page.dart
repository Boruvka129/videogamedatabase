import 'package:flutter/material.dart';
import 'package:gamedatabaseapp/components/bottom_navbar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:gamedatabaseapp/components/carousel_slider.dart';
import 'package:gamedatabaseapp/components/RPG_column.dart';
import 'package:gamedatabaseapp/components/strategy_column.dart';
import 'package:gamedatabaseapp/services/API/api_calls.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 25.0, top: 16.0, bottom: 16.0),
              child: Container(
                height: 300,
                width: double.infinity,
                child: Center(
                  child: PopularGamesCarousel(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RPGColumn(),
                  SizedBox(height: 16.0),
                  StrategyColumn(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
