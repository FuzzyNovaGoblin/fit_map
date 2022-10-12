import 'package:fit_map/data/a_star.dart';
import 'package:fit_map/data/coord_tools.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:location/location.dart';

import 'map_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(children: [
        const Text("current location"),
        StreamBuilder(
            stream: location.onLocationChanged,
            builder: ((context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return const CircularProgressIndicator();
                case ConnectionState.waiting:
                  return const Text("loading...");
                case ConnectionState.done:
                case ConnectionState.active:
                  LocationData data = snapshot.data!;
                  startPoint = LatLng(data.latitude!, data.longitude!);
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
                icon: const Icon(Icons.search),
                onPressed: searchButtonEnabled
                    ? () {
                        setState(() => searchButtonEnabled = false);
                        geo
                            .locationFromAddress(destinationTextEditingController.text)
                            .onError((error, stackTrace) {
                              return [];
                            })
                            .catchError((error, st) {})
                            .whenComplete(() {
                              setState(() => searchButtonEnabled = true);
                            })
                            .then((value) {
                              if (value.isNotEmpty) {
                                destination = LatLng(value[0].latitude, value[0].longitude);
                              }
                            });
                      }
                    : null,
              )
            ],
          ),
        ),
        const Text("destination"),
        Text("${destination.latitude},${destination.longitude}"),
        MaterialButton(
          child: const Text("GO!"),
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MapPage(
                        startPoint: startPoint,
                        destination: destination,
                      ))),
        ),
        MaterialButton(
          child: Text("test a star"),
          onPressed: () {
            aStarSearch(Coord(startPoint.latitude, startPoint.longitude), Coord(destination.latitude, destination.longitude));
          },
        )
      ]),
    );
  }
}
