// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables
// TODO: get rid of these ^^

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:location/location.dart';
// import 'package:g_map';

class MapPage extends StatefulWidget {
  final LatLng startPoint;
  final LatLng destination;

  MapPage({super.key, required this.startPoint, required this.destination});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  LatLng destination = const LatLng(39.5, -98.35);
  bool searchButtonEnabled = true;

  Location location = Location();
  // Location location = new Location();

  late GoogleMapController mapController;
  late TextEditingController destinationTextEditingController;

  @override
  void initState() {
    super.initState();
    destinationTextEditingController = TextEditingController();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(children: [
        GoogleMap(
          onMapCreated: _onMapCreated,
          rotateGesturesEnabled: true,
          markers: {Marker(markerId: MarkerId("start"), position: widget.startPoint), Marker(markerId: MarkerId("destination"), position: widget.destination)},
          initialCameraPosition: CameraPosition(
            target: widget.startPoint,
            zoom: 3.5,
          ),
        ),
      ]),
    );
  }
}
