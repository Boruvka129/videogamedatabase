import 'package:flutter/material.dart';
import 'package:gamedatabaseapp/components/bottom_navbar.dart';
import 'package:gamedatabaseapp/pages/home_page.dart';
import 'package:gamedatabaseapp/pages/account_page.dart';
import 'package:gamedatabaseapp/pages/search_page.dart';
import 'package:provider/provider.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final selectedIndex =
        Provider.of<SelectedIndexProvider>(context).selectedIndex;
    return Scaffold(
        bottomNavigationBar: NavBar(), body: NavBar.pages[selectedIndex]);
  }
}
