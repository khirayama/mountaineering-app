import 'package:flutter/material.dart';

class HomeBody extends StatefulWidget {
  HomeBody({Key key, this.index}) : super(key: key);

  final int index;

  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  @override
  Widget build(BuildContext context) {
    return Center(
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
    );
  }
}
