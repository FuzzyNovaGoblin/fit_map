import 'package:fit_map/data/a_star.dart';
import 'package:fit_map/data/coord_tools.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  final LatLng startPoint;
  final LatLng destination;

  const MapPage({super.key, required this.startPoint, required this.destination});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  bool searchButtonEnabled = true;


  late GoogleMapController mapController;
  late TextEditingController destinationTextEditingController;
  List<Coord> coords = [];

  @override
  void initState() {
    super.initState();
    destinationTextEditingController = TextEditingController();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  List<LatLng> coordListTOLatLngList(List<Coord> coords) {
    List<LatLng> ret = [];
    for (var coord in coords) {
      ret.add(LatLng(coord.lat, coord.lon));
    }
    return ret;
  }

  Set<Polyline> _getPolyLines(List<Coord> dataPoints) {
    Set<Polyline> mapPolyLines = Set<Polyline>();

    mapPolyLines.add(Polyline(
      polylineId: PolylineId("line"),
      color: Colors.purple,
      points: coordListTOLatLngList(dataPoints),
      width: 5,
      jointType: JointType.round,
      endCap: Cap.roundCap,
      startCap: Cap.roundCap,
    ));
    print("mapPolyLines:${mapPolyLines.length} $mapPolyLines");
    return mapPolyLines;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(children: [
        GoogleMap(
          onMapCreated: _onMapCreated,
          rotateGesturesEnabled: true,
          polylines: _getPolyLines(aStarSearch(Coord(widget.startPoint.latitude, widget.startPoint.longitude), Coord(widget.destination.latitude, widget.destination.longitude))),
          markers: {Marker(markerId: MarkerId("start"), position: widget.startPoint), Marker(markerId: MarkerId("destination"), position: widget.destination)},
          initialCameraPosition: CameraPosition(
            target: widget.startPoint,
            zoom: 3.5,
          ),
        )
      ]),
    );
  }
}
