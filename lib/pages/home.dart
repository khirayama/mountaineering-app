import 'package:flutter/material.dart';

import '../components/home_body.dart';
import '../components/map_body.dart';
import '../components/profile_body.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.index}) : super(key: key);

  int index;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<int> _tabStack = <int>[0];

  List<Widget> _tabs = [
    HomeBody(),
    MapBody(),
    ProfileBody(),
  ];

  void _onItemTapped(int index) => setState(() {
    if (_tabStack[_tabStack.length - 1] == index) {
      return;
    }
    setState(() {
      _tabStack.add(index);
    });
  });

  @override
  void initState() {
    setState(() {
      _tabStack = [widget.index];
    });
  }

  @override
  Widget build(BuildContext context) {
    int index = _tabStack[_tabStack.length - 1];

    return SafeArea(
      child: Scaffold(
        body: _tabs.elementAt(index),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: 'Map'),
            BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined), label: 'Profile'),
          ],
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: index,
          fixedColor: Colors.blueAccent,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
        ),
      )
    );
  }
}
