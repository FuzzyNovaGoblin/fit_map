// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables
// TODO: get rid of these ^^

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:location/location.dart';

import 'map_page.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LatLng destination = const LatLng(0, 0);
  LatLng startPoint = const LatLng(0, 0);

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
      body: Column(children: [
        Text("current location"),
        StreamBuilder(
            stream: location.onLocationChanged,
            builder: ((context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Placeholder();
                case ConnectionState.waiting:
                  return Text("loading...");
                case ConnectionState.done:
                case ConnectionState.active:
                  LocationData data = snapshot.data!;
                  startPoint = LatLng(data.latitude!,data.longitude!);
                  return Text("${data.latitude}, ${data.longitude}");
              }
            })),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 50.0),
                  child: TextField(
                    controller: destinationTextEditingController,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: searchButtonEnabled
                    ? () {
                        setState(() {
                          searchButtonEnabled = false;
                          geo.locationFromAddress(destinationTextEditingController.text).then((value) {
                            searchButtonEnabled = true;
                            if (value.isNotEmpty) {
                              destination = LatLng(value[0].latitude, value[0].longitude);
                            }
                            setState(() {});
                          });
                        });
                      }
                    : null,
              )
            ],
          ),
        ),
        Text("destination"),
        Text("${destination.latitude},${destination.longitude}"),
        MaterialButton(
          child: Text("GO!"),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MapPage(startPoint: startPoint, destination: destination,))),
        )
      ]),
    );
  }
}
