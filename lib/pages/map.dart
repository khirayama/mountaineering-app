import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import '../components/navigation.dart';

class MapPage extends StatefulWidget {
  MapPage({Key key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MapboxMap(
          accessToken: 'pk.eyJ1Ijoia2hpcmF5YW1hIiwiYSI6ImNqa2YycGZ1ejA0bnQzdm8za2w3dnkxdmwifQ.Xf4dKzaKSxv_CTDqkyt_ug',
          initialCameraPosition: CameraPosition(
            zoom: 15.0,
            target: LatLng(14.508, 46.048),
          ),
        ),
      ),
      bottomNavigationBar: Navigation(index: 1),
    );
  }
}
