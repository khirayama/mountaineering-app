import 'package:flutter/material.dart';

import './home_page.dart';
import './map_page.dart';
import './profile_page.dart';
import './post_page.dart';

void main() {
  runApp(
    MaterialApp(
      initialRoute: '/',
      routes: <String, WidgetBuilder> {
        '/': (BuildContext context) => HomePage(),
        '/map': (BuildContext context) => MapPage(),
        '/profile': (BuildContext context) => ProfilePage(),
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
