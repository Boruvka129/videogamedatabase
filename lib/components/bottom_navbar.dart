import 'package:flutter/material.dart';
import 'package:gamedatabaseapp/pages/account_page.dart';
import 'package:gamedatabaseapp/pages/home_page.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:gamedatabaseapp/pages/search_page.dart';
import 'package:provider/provider.dart';

class NavBar extends StatefulWidget {
  int _selectedIndex = 0;
  static final List<Widget> pages = [
    HomePage(),
    SearchPage(),
    AccountPage(),
  ];
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    SelectedIndexProvider selectedIndexProvider =
        Provider.of<SelectedIndexProvider>(context);
    return SafeArea(
      child: GNav(
        selectedIndex:
            selectedIndexProvider.selectedIndex,
        backgroundColor: Colors.black,
        color: Colors.white,
        activeColor: Colors.white,
        tabBackgroundColor: Colors.grey.shade800,
        gap: 8,
        padding: EdgeInsets.all(16),
        tabs: [
          GButton(
            icon: Icons.home,
            text: 'Home',
            onPressed: () {
              setState(() {
                selectedIndexProvider
                    .setSelectedIndex(0);
              });
            },
          ),
          GButton(
            icon: Icons.search,
            text: 'Search',
            onPressed: () {
              setState(() {
                selectedIndexProvider.setSelectedIndex(1);
              });
            },
          ),
          GButton(
            icon: Icons.account_box,
            text: 'Account',
            onPressed: () {
              setState(() {
                selectedIndexProvider.setSelectedIndex(2);
              });
            },
          ),
        ],
      ),
    );
  }
}

class SelectedIndexProvider extends ChangeNotifier {
  static SelectedIndexProvider _selectedIndexProvider = SelectedIndexProvider();
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
