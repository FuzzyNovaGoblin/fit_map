import 'package:collection/collection.dart' show PriorityQueue;
import 'package:fit_map/data/coord_tools.dart';
import 'package:fit_map/data/nodes.dart';

class AStarNode with Comparable<AStarNode> {
  late List<AStarPoint> beenTo;
  double distanceTraveled;
  double estimatedCost;

  AStarNode.fromPoint(AStarPoint point)
      : distanceTraveled = 0,
        estimatedCost = point.g {
    beenTo = [point];
  }

  AStarNode.otherAndPoint(AStarNode other, AStarPoint point) : this._otherAndPoint(other, point);

  AStarNode.copyOther(AStarNode other) : this._otherAndPoint(other, null);

  AStarNode._otherAndPoint(AStarNode other, AStarPoint? point)
      : distanceTraveled = other.distanceTraveled,
        estimatedCost = other.estimatedCost {
    beenTo = [];
    for (var node in other.beenTo) {
      beenTo.add(node);
    }
    if (point != null) {
      distanceTraveled += beenTo.last.distance(point).abs();
      estimatedCost = distanceTraveled + beenTo.last.g;
      beenTo.add(point);
    }
  }

  double get remainingDistance => beenTo.last.g;

  @override
  int compareTo(AStarNode other) => estimatedCost.compareTo(other.estimatedCost);
}

class AStarPoint extends Coord with Comparable<AStarPoint> {
  late double g;

  AStarPoint(Coord point, Coord destination) : super(point.lat, point.lon) {
    g = distance(destination);
  }

  @override
  int compareTo(AStarPoint other) => g.compareTo(other.g);
}

List<Coord> aStarSearch(Coord start, Coord end) {
  PriorityQueue<AStarNode> nodes = PriorityQueue();
  PriorityQueue<AStarPoint> points = PriorityQueue();

  for (Coord coord in NODES) {
    points.add(AStarPoint(coord, end));
  }
  points.add(AStarPoint(end, end));

  // for (var point in points.toList().reversed) {
  //   print("point g: ${point.g}");
  // }

  nodes.add(AStarNode.fromPoint(AStarPoint(start, end)));

  while (nodes.isNotEmpty) {
    AStarNode node = nodes.removeFirst();

    print("current distance ${node.remainingDistance}");

    if (node.remainingDistance == 0) {
      print("done");
      return node.beenTo;
    }

    for (var adjacent in node.beenTo.last.findAdjacents(points.toList())) {
      points.remove(adjacent as AStarPoint);
      nodes.add(AStarNode.otherAndPoint(node, adjacent as AStarPoint));
    }
  }

  throw UnsupportedError("a star failed");
}
