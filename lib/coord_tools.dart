import 'dart:ffi';
import 'dart:convert';
import 'dart:core';
import 'package:fit_map/nodes.dart';
import 'dart:math';

class Coord {
  double lat = 0;
  double lon = 0;
  Coord(double lat, double lon) {
    this.lat = lat;
    this.lon = lon;
  }

  String toString() {
    return lat.toString() + " " + lon.toString();
  }
}

// Takes massive string containing one node then a new line in the format: {id lat lon}
List<Coord> parseCoords(String str) {
  // str is split into lines.
  LineSplitter ls = new LineSplitter();
  List<String> lines = ls.convert(str);

  // list of all nodes to be built (as coordinates)
  List<Coord> coords = [];
  for (var i = 0; i < lines.length; i++) {  // For each line
    var lineLst = lines[i].split(' ');
    // Remove's the id at the beginning of the line.
    lineLst.removeAt(0);
    // Get lat and lon as doubles, make a Coord object and append to list.
    var lat = double.parse(lineLst[0]);
    var lon = double.parse(lineLst[1]);
    coords.add(Coord(lat, lon));
  }
  return coords;
}

// Takes a single point and all points. Finds adjacent coords.
List<Coord> findAdjacents(Coord loc, List<Coord> allCoords) {
  List<Coord> adj = [];
  for (var i = 0; i < allCoords.length; i++) {  // For each coord
    // Pythagorean distance between the two coords.
    var dist = sqrt(pow((allCoords[0].lat - allCoords[i].lat).abs(), 2) + pow((allCoords[0].lon - allCoords[i].lon).abs(), 2));
    // Excludes the given coord.
    if (dist < 0.0002 && dist != 0) {
      adj.add(allCoords[i]);
    }
  }
  return adj;
}

void testing() {
  /*
  // Test code looks at coords adjacent to the first coord in the list.
  List<Coord> coords = parseCoords(strVar);
  List<Coord> adj = findAdjacents(coords[0], coords);

  print("Coords length: " + coords.length.toString());
  print("Adj length: " + adj.length.toString());
  print(coords[0]);
  for (var i = 0; i < adj.length; i++) {
    print(adj[i].toString());
  }
  */
}