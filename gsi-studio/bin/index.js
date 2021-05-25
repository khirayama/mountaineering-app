const fs = require("fs");

const data = require("../public/base.json");

const template = (json) => {
  return `String styleJSON = '''${JSON.stringify(json)}''';`;
};

const key = "gsi-mapbox";

const mixed = {
  version: 8,
  name: "mixed",
  id: key,
  glyphs:
    "https://cyberjapandata.gsi.go.jp/xyz/noto-jp/{fontstack}/{range}.pbf",
  sources: {
    [key + "-vector"]: {
      type: "vector",
      tiles: [
        "https://cyberjapandata.gsi.go.jp/xyz/experimental_bvmap/{z}/{x}/{y}.pbf",
      ],
      maxzoom: 16,
      minzoom: 4,
      attribution:
        "<a href='https://maps.gsi.go.jp/vector/' target='_blank'>地理院地図Vector（仮称）</a>",
    },
    // [key + "-raster"]: {
    //   type: "raster",
    //   tiles: [
    //     "https://cyberjapandata.gsi.go.jp/xyz/pale/{z}/{x}/{y}.png",
    //     // 'https://cyberjapandata.gsi.go.jp/xyz/std/{z}/{x}/{y}.png',
    //     // 'https://cyberjapandata.gsi.go.jp/xyz/blank/{z}/{x}/{y}.png',
    //   ],
    //   tileSize: 256,
    //   attribution:
    //     "<a href='https://maps.gsi.go.jp/' target='_blank'>地理院地図</a>",
    // },
  },
  layers: [
    {
      id: "background",
      type: "background",
      paint: {
        "background-color": "rgba(255, 255, 255, 1)",
      },
    },
    // {
    //   'id': key + '-raster',
    //   'type': 'raster',
    //   'source': key + '-raster',
    //   'minzoom': 0,
    //   'maxzoom': 22
    // },
  ],
};

const base = mixed;

const typeSet = new Set();
const sourceLayerSet = new Set();
const overview = {};
const dataset = {};

data.layers.forEach((layer) => {
  const type = layer["type"];
  const sourceLayer = layer["source-layer"];

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
      overview[type][sourceLayer] = 1;
    } else {
      overview[type] = {
        [layer["source-layer"]]: 1,
      };
    }
  }
});

console.log("----- type -----");
console.log(typeSet);
console.log("----- source-layer -----");
console.log(sourceLayerSet);
console.log("----- overview -----");
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
    // 'symbol',
    // 'searoute',
    // 'boundary',
    // 'building',
    // 'road',
    // 'railway',
    // 'elevation',
    // 'label',
    // 'transp',
  ];
  if (blockSourceLayers.indexOf(layer["source-layer"]) !== -1) {
    return false;
  }

  return true;
}

function transform(layer) {
  layer.source = key + "-vector";
  // console.log(layer.metadata);

  // delete layer.metadata;
  // layer.minzoom = 4;
  // layer.maxzoom = 16;
  return layer;
}

base.layers = base.layers.concat(
  data.layers.filter(layerFilter).map(transform)
);

fs.writeFileSync("./public/dataset.json", JSON.stringify(dataset));
fs.writeFileSync("./public/preview.json", JSON.stringify(base));
fs.writeFileSync("../lib/components/map_body_style_json.dart", template(base));
