import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import '../secret.dart';

CameraPosition _cachedCameraPosition = CameraPosition(
  zoom: 9.0,
  target: LatLng(33.556457, 130.480625),
);

class MapBody extends StatefulWidget {
  MapBody({Key key}) : super(key: key);

  @override
  _MapBodyState createState() => _MapBodyState();
}

class _MapBodyState extends State<MapBody> {
  MapboxMapController _controller;

  void _onMapChanged() {
    _cachedCameraPosition = _controller.cameraPosition;
    setState(() {
      _cameraPosition = _controller.cameraPosition;
    });
  }

  CameraPosition _cameraPosition = _cachedCameraPosition;

  @override
  Widget build(BuildContext context) {
    final MapboxMap mapboxMap = MapboxMap(
      accessToken: MAPBOX_ACCESS_TOKEN,
      initialCameraPosition: _cameraPosition,
      trackCameraPosition: true,
      styleString: MAPBOX_STYLE_STRING,
      minMaxZoomPreference: MinMaxZoomPreference(4, 16),
      onMapCreated: (MapboxMapController controller) {
        _controller = controller;
        _cameraPosition = controller.cameraPosition;
        _controller.addListener(_onMapChanged);
      },
    );

    return Stack(
      children: [
        Center(child: mapboxMap),
        Column(
          children: [
            Text(_cameraPosition != null ? _cameraPosition.zoom.toString() : 'null'),
            Text(_cameraPosition != null ? _cameraPosition.target.toString() : 'null'),
          ],
        ),
      ],
    );
  }
}
