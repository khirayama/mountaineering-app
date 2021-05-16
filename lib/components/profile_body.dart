import 'package:flutter/material.dart';

class ProfileBody extends StatefulWidget {
  ProfileBody({Key key, this.index}) : super(key: key);

  final int index;

  @override
  _ProfileBodyState createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Profile'),
        ],
      ),
    );
  }
}
