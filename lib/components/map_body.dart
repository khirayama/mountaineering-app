import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:path_provider/path_provider.dart';

import '../secret.dart';
import './map_body_style_json.dart';

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

  String styleAbsoluteFilePath;

  @override
  initState() {
    super.initState();

    getApplicationDocumentsDirectory().then((dir) async {
      String documentDir = dir.path;
      String stylesDir = '$documentDir/styles';

      await new Directory(stylesDir).create(recursive: true);

      File styleFile = new File('$stylesDir/style.json');

      await styleFile.writeAsString(styleJSON);

      setState(() {
        styleAbsoluteFilePath = styleFile.path;
      });
    });
  }

  void _onMapChanged() {
    _cachedCameraPosition = _controller.cameraPosition;
    setState(() {
      _cameraPosition = _controller.cameraPosition;
    });
  }

  CameraPosition _cameraPosition = _cachedCameraPosition;

  @override
  Widget build(BuildContext context) {
    if (styleAbsoluteFilePath == null) {
      return Scaffold(
        body: Center(child: Text('Creating local style file...')),
      );
    }

    final MapboxMap mapboxMap = MapboxMap(
      accessToken: MAPBOX_ACCESS_TOKEN,
      initialCameraPosition: _cameraPosition,
      trackCameraPosition: true,
      styleString: styleAbsoluteFilePath,
      minMaxZoomPreference: MinMaxZoomPreference(4, 16),
      onMapCreated: (MapboxMapController controller) {
        _controller = controller;
        _cameraPosition = controller.cameraPosition;
        _controller.addListener(_onMapChanged);
      },
      onStyleLoadedCallback: () {
        print('Hello');
        List<LatLng> geometries = [
            LatLng(33.556457, 130.480625),
            LatLng(34.556457, 131.480625),
            LatLng(35.556457, 130.480625),
            LatLng(35.556457, 131.480625),
        ];
        _controller.addLine(LineOptions(
          lineColor: '#ff0000',
          geometry: geometries,
        ));
        List<CircleOptions> circleOptions = geometries.map((LatLng geo) {
            print(geo);
            return CircleOptions(
              circleColor: '#ff0000',
              circleRadius: 4,
              geometry: geo,
            );
          }).toList();
        _controller.addCircles(circleOptions);
        _controller.addSymbols([
          SymbolOptions(
            geometry: LatLng(33.556457, 130.480625),
            fontNames: ['DIN Offc Pro Bold', 'Arial Unicode MS Regular'],
            textField: 'hogehoge',
            textSize: 12.5,
            textOffset: Offset(0, 0.8),
            textAnchor: 'top',
            textColor: '#ff0000',
            textHaloColor: '#ff0000',
            textHaloWidth: 0.8,
          )
        ]);
      }
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
