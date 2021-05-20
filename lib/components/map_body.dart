import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:path_provider/path_provider.dart';

import '../secret.dart';
// import '../map_style.dart';

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
      // String styleJSON = '{"version":8,"name":"Basic","constants":{},"sources":{"mapillary":{"type":"vector","tiles":["https://d25uarhxywzl1j.cloudfront.net/v0.1/{z}/{x}/{y}.mvt"],"attribution":"<a href=\\"https://www.mapillary.com\\" target=\\"_blank\\">© Mapillary, CC BY</a>","maxzoom":14}},"sprite":"","glyphs":"","layers":[{"id":"background","type":"background","paint":{"background-color":"rgba(135, 149, 154, 1)"}},{"id":"water","type":"fill","source":"mapbox","source-layer":"water","paint":{"fill-color":"rgba(108, 148, 120, 1)"}}]}';
      String styleJSON = '''
{
  "version": 8,
  "name": "Basic",
  "constants": {},
  "sources": {
    "gsibv-vectortile-source-1-4-16": {
      "type": "vector",
      "tiles": [
        "https://cyberjapandata.gsi.go.jp/xyz/experimental_bvmap/{z}/{x}/{y}.pbf"
      ],
      "attribution": "",
      "minzoom": 4,
      "maxzoom": 16
    }
  },
  "sprite": "",
  "glyphs": "",
  "layers": [
{"id":"gsibv-vectortile-layer-1","type":"line","source":"gsibv-vectortile-source-1-4-16","source-layer":"structurel","metadata":{"layer-id":"layer-29","title":"坑口","path":"構造物-坑口","added":1},"minzoom":14,"maxzoom":17,"filter":["all",["in","ftCode",4202]],"layout":{"line-cap":"square","visibility":"visible"},"paint":{"line-color":"rgba(100,100,100,1)","line-width":1.5}},
{"id":"gsibv-vectortile-layer-2","type":"line","source":"gsibv-vectortile-source-1-4-16","source-layer":"river","metadata":{"layer-id":"layer-289","title":"人工水路（地下）","path":"河川-人工水路（地下）","added":1},"minzoom":8,"maxzoom":14,"filter":["all",["in","ftCode",5322]],"layout":{"line-cap":"square","visibility":"visible"},"paint":{"line-color":"rgb(190,210,255)","line-width":{"stops":[[9,1],[17,2]]},"line-dasharray":[2,2]}},
{"id":"gsibv-vectortile-layer-3","type":"line","source":"gsibv-vectortile-source-1-4-16","source-layer":"river","metadata":{"layer-id":"layer-290","title":"人工水路（地下）","path":"河川-人工水路（地下）","added":1},"minzoom":14,"maxzoom":17,"filter":["all",["in","ftCode",5322]],"layout":{"line-cap":"square","visibility":"visible"},"paint":{"line-color":"rgb(20,90,255)","line-width":1.5,"line-dasharray":[5,5]}},
{"id":"gsibv-vectortile-layer-4","type":"line","source":"gsibv-vectortile-source-1-4-16","source-layer":"river","metadata":{"layer-id":"layer-284","title":"枯れ川部","path":"河川-枯れ川部","added":1},"minzoom":8,"maxzoom":14,"filter":["all",["in","ftCode",5302]],"layout":{"line-cap":"square","visibility":"visible"},"paint":{"line-color":"rgb(190,210,255)","line-width":{"stops":[[9,1],[17,2]]},"line-dasharray":[2,2]}},
{"id":"gsibv-vectortile-layer-5","type":"line","source":"gsibv-vectortile-source-1-4-16","source-layer":"river","metadata":{"layer-id":"layer-285","title":"枯れ川部","path":"河川-枯れ川部","added":1},"minzoom":14,"maxzoom":17,"filter":["all",["in","ftCode",5302]],"layout":{"line-cap":"square","visibility":"visible"},"paint":{"line-color":"rgb(20,90,255)","line-width":1.5,"line-dasharray":[5,1.5]}},
{"id":"gsibv-vectortile-layer-6","type":"line","source":"gsibv-vectortile-source-1-4-16","source-layer":"river","metadata":{"layer-id":"layer-286","title":"枯れ川部","path":"河川-枯れ川部","added":1},"minzoom":17,"maxzoom":18,"filter":["all",["in","ftCode",5302]],"layout":{"line-cap":"square","visibility":"visible"},"paint":{"line-color":"rgb(20,90,255)","line-width":1}},
{"id":"gsibv-vectortile-layer-7","type":"fill","source":"gsibv-vectortile-source-1-4-16","source-layer":"waterarea","metadata":{"layer-id":"layer-1","title":"水域","path":"水域","added":1},"minzoom":4,"maxzoom":17,"filter":["all",["in","ftCode",55000,5000]],"layout":{"visibility":"visible"},"paint":{"fill-color":"rgb(190,210,255)"}},
{"id":"gsibv-vectortile-layer-8","type":"fill","source":"gsibv-vectortile-source-1-4-16","source-layer":"waterarea","metadata":{"layer-id":"layer-2","title":"水域","path":"水域","added":1},"minzoom":17,"maxzoom":18,"filter":["all",["in","ftCode",5000]],"layout":{"visibility":"visible"},"paint":{"fill-color":"rgb(254,254,255)"}}
  ]
}
''';

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
