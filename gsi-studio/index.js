const fs = require('fs');

const data = require('./base.json');

const template = (json) => {
  return `String styleJSON = '''${JSON.stringify(json)}''';`
};

const key = 'gsi-mapbox';

const vector = {
  "version": 8,
  "name": "Vector",
  "sources": {
    [key]: {
      "type": "vector",
      "tiles": [
        "https://cyberjapandata.gsi.go.jp/xyz/experimental_bvmap/{z}/{x}/{y}.pbf"
      ],
      "maxzoom": 16,
      "minzoom": 4,
      "attribution": "<a href='https://maps.gsi.go.jp/vector/' target='_blank'>地理院地図Vector（仮称）</a>"
    }
  },
  glyphs: "https://cyberjapandata.gsi.go.jp/xyz/noto-jp/{fontstack}/{range}.pbf",
  // glyphs: "https://cyberjapandata.gsi.go.jp/xyz/noto-jp/{fontstack}/0-18030.pbf",
  // glyphs: "mapbox://fonts/mapbox/{fontstack}/{range}.pbf?access_token=pk.eyJ1Ijoia2hpcmF5YW1hIiwiYSI6ImNqa2YycGZ1ejA0bnQzdm8za2w3dnkxdmwifQ.Xf4dKzaKSxv_CTDqkyt_ug",
  // glyphs: "https://glyphs.geolonia.com/{fontstack}/{range}.pbf",
  "layers": [
    {
      "id": "background",
      "type": "background",
      "paint": {
        "background-color": "rgba(255, 255, 255, 1)"
      }
    },
  ],
  "id": key,
};

const rastor = {
  'version': 8,
  'sources': {
    [key]: {
      'type': 'raster',
      'tiles': [
        'https://cyberjapandata.gsi.go.jp/xyz/std/{z}/{x}/{y}.png',
        // 'https://cyberjapandata.gsi.go.jp/xyz/blank/{z}/{x}/{y}.png',
      ],
      'tileSize': 256,
      'attribution': ''
    }
  },
  'layers': [
    {
      'id': key,
      'type': 'raster',
      'source': key,
      'minzoom': 0,
      'maxzoom': 22
    }
  ]
};

const mixed = {
  "version": 8,
  "name": "mixed",
  "id": key,
  "sources": {
    [key + '-vector']: {
      "type": "vector",
      "tiles": [
        "https://cyberjapandata.gsi.go.jp/xyz/experimental_bvmap/{z}/{x}/{y}.pbf"
      ],
      "maxzoom": 16,
      "minzoom": 4,
      "attribution": "<a href='https://maps.gsi.go.jp/vector/' target='_blank'>地理院地図Vector（仮称）</a>"
    },
    [key + '-raster']: {
      'type': 'raster',
      'tiles': [
        'https://cyberjapandata.gsi.go.jp/xyz/std/{z}/{x}/{y}.png',
        // 'https://cyberjapandata.gsi.go.jp/xyz/blank/{z}/{x}/{y}.png',
      ],
      'tileSize': 256,
      'attribution': ''
    }
  },
  glyphs: "https://cyberjapandata.gsi.go.jp/xyz/noto-jp/{fontstack}/{range}.pbf",
  layers: [
    {
      'id': key + '-raster',
      'type': 'raster',
      'source': key + '-raster',
      'minzoom': 0,
      'maxzoom': 22
    },
  ],
};

const base = mixed;

const typeSet = new Set();
const sourceLayerSet = new Set();
const overview = {};
const dataset = {};

data.layers.forEach((layer) => {
  const type = layer['type'];
  const sourceLayer = layer['source-layer'];

  typeSet.add(type);
  sourceLayerSet.add(sourceLayer);

  if (dataset[sourceLayer]) {
    dataset[sourceLayer].push(layer);
  } else {
    dataset[sourceLayer] = [layer];
  }

  if (overview[type] && overview[type][sourceLayer]) {
    overview[type][sourceLayer] += 1;
  } else {
    if (overview[type]) {
      overview[type][sourceLayer] = 1
    } else {
      overview[type] = {
        [layer['source-layer']]: 1,
      };
    }
  }
});

console.log('----- type -----');
console.log(typeSet);
console.log('----- source-layer -----');
console.log(sourceLayerSet);
console.log('----- overview -----');
console.log(overview);

function layerFilter(layer) {
  const blockSourceLayers = [
    // 'landformp',
    // 'structurel',
    // 'river',
    // 'waterarea',
    // 'lake',
    // 'landforml',
    // 'landforma',
    // 'coastline',
    // 'contour',
    // 'wstructurea',
    // 'structurea',
    // // 'symbol',
    // 'searoute',
    // 'boundary',
    // 'building',
    // 'road',
    // 'railway',
    // 'elevation',
    // 'label',
    // 'transp',
  ];
  if (blockSourceLayers.indexOf(layer['source-layer']) !== -1) {
    return  false;
  }

  return true;
};

function transform(layer) {
  layer.source = key + '-vector';

  if (layer.layout && layer.layout['text-field']) {
    console.log(layer.layout['text-field']);
    delete layer.layout['text-field'];
    // if (layer.layout['text-field'] === '{name}') {
    //   layer.layout['text-field'] = "unicode";
    // }
  }

  // delete layer.metadata;
  // layer.minzoom = 4;
  // layer.maxzoom = 16;
  return layer;
}

// base.layers = base.layers.concat(data.layers.filter(layerFilter).map(transform));
base.layers = data.layers.filter(layerFilter).map(transform).concat(base.layers);

fs.writeFileSync('./dataset.json', JSON.stringify(dataset));
fs.writeFileSync('./preview.json', JSON.stringify(base));
fs.writeFileSync('../lib/components/map_body_style_json.dart', template(base));
