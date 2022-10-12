import 'dart:core';
import 'dart:math';

class Coord {
  final double lat;
  final double lon;
  const Coord(this.lat, this.lon);

  @override
  String toString() {
    return "$lat $lon";
  }

  double distance(Coord other) => sqrt(pow((lat - other.lat).abs(), 2) + pow((lon - other.lon).abs(), 2));

// Takes a single point and all points. Finds adjacent coords.
  List<Coord> findAdjacents(List<Coord> allCoords) {
    List<Coord> adj = [];
    for (var i = 0; i < allCoords.length; i++) {
      // For each coord
      // Pythagorean distance between the two coords.
      double dist = distance(allCoords[i]);

      // Excludes the given coord.
      if (dist < 0.00085 && dist != 0) {
        adj.add(allCoords[i]);
      }
    }
      return adj;
  }
}
