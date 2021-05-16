import 'package:flutter/material.dart';

import './pages/home.dart';
import './pages/map.dart';
import './pages/profile.dart';
import './pages/post.dart';

void main() {
  runApp(
    MaterialApp(
      initialRoute: '/',
      routes: <String, WidgetBuilder> {
        '/': (BuildContext context) => HomePage(index: 0),
        '/map': (BuildContext context) => HomePage(index: 1),
        '/profile': (BuildContext context) => HomePage(index: 2),
        '/post': (BuildContext context) => PostPage(),
      },
      title: 'Flutter Demo',
      theme: new ThemeData(
        primaryColor: Colors.white,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
    )
  );
}
