import 'package:flutter/material.dart';

import '../pages/home.dart';
import '../pages/map.dart';
import '../pages/profile.dart';

class Navigation extends StatefulWidget {
  Navigation({Key key, this.index}) : super(key: key);

  final int index;

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  void _onItemTapped(int index) => setState(() {
    if (widget.index == index) {
      return;
    }

    switch (index) {
      case 0:
        Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => HomePage(),
        ));
        break;
      case 1:
        Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => MapPage(),
        ));
        break;
      case 2:
        Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => ProfilePage(),
        ));
        break;
    }
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: 'Map'),
        BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined), label: 'Profile'),
      ],
      showSelectedLabels: false,
      showUnselectedLabels: false,
      currentIndex: widget.index,
      fixedColor: Colors.blueAccent,
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
    );
  }
}
