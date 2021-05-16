import 'package:flutter/material.dart';

import './components/navigation.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Home'),
            OutlinedButton(
                child: const Text('Push'),
                onPressed: () {
                  Navigator.of(context).pushNamed('/post');
                },
              ),
          ],
        ),
      ),
      bottomNavigationBar: Navigation(index: 0),
    );
  }
}
