import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import '../secret.dart';

class MapBody extends StatefulWidget {
  MapBody({Key key, this.index}) : super(key: key);

  final int index;

  @override
  _MapBodyState createState() => _MapBodyState();
}

class _MapBodyState extends State<MapBody> {
  MapboxMapController _controller;

  double _zoom = 15.0;

  LatLng _target = LatLng(14.508, 46.048);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: MapboxMap(
            accessToken: MAPBOX_ACCESS_TOKEN,
            initialCameraPosition: CameraPosition(
              zoom: _zoom,
              target: _target,
            ),
            onMapCreated: (MapboxMapController controller) {
              _controller = controller;
            },
            // onMapLongClick: (context) {
            //   print('maplongclick');
            // },
            onUserLocationUpdated: (context) {
              print('userlocationupdated');
            },
            onCameraIdle: () {
              print('--- cameraidle ---');
              print(_controller.cameraPosition);
              setState(() {
                _zoom = _controller.cameraPosition.zoom;
                _target = _controller.cameraPosition.target;
              });
            },
          ),
        ),
        Column(
          children: [
            Text(_zoom.toString()),
            Text(_target.toString()),
          ],
        ),
      ],
    );

  }
}
