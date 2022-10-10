// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'dart:math' as math;

// class Pnt with Comparable {
//   late int key;
//   double lat;
//   double lng;

//   Pnt(String key, this.lat, this.lng) {
//     this.key = int.parse(key);
//   }

//   @override
//   int compareTo(other) {
//     return key < other.key ? -1 : 1;
//   }
// }

// class MapView extends StatefulWidget {
//   @override
//   _MapViewState createState() => _MapViewState();
// }

// class _MapViewState extends State<MapView> {
//   late GoogleMapController mapController;
//   List<LatLng> pnts = [];

//   double distanceFormula(double x1, double y1, double x2, double y2) {
//     return math.sqrt(math.pow(x2 - x1, 2) + math.pow(y2 - y1, 2));
//   }

//   @override
//   void dispose() {
//     mapController.dispose();
//     super.dispose();
//   }

//   final LatLng _center = const LatLng(39.5, -98.35);

//   void _onMapCreated(GoogleMapController controller) {
//     mapController = controller;
//   }

//   Set<Marker> _getMapMarkers() {
//     Set<Marker> mapMarkers = Set<Marker>();

//     mapMarkers.add(Marker(
//         position: pnts.last,
//         markerId: MarkerId("box"),

//         onTap: () => mapController.animateCamera(CameraUpdate.newCameraPosition(
//               CameraPosition(
//                 target: pnts.last,
//                 zoom: 25,
//               ),
//             ))));
//     // mapMarkers.add(Marker(
//     //   markerId: MarkerId("goal"),
//     //   position: FuzSingleton().goalPnt,
//     //   icon: FuzSingleton().goalBeastBitmap,
//     // ));
//     // mapMarkers.add(Marker(
//     //   markerId: MarkerId("start"),
//     //   position: FuzSingleton().startPnt,
//     //   icon: FuzSingleton().startPinBitmap,
//     // ));
//     return mapMarkers;
//   }

//   // double _getRemainingDistence() {
//   //   List<double> reachPnt = [pnts.last.latitude, pnts.last.longitude];
//   //   List<double> startPnt = [FuzSingleton().startPnt.latitude, FuzSingleton().startPnt.longitude];
//   //   List<double> endPnt = [FuzSingleton().goalPnt.latitude, FuzSingleton().goalPnt.longitude];
//   //   double totalDst = distanceFormula(startPnt[0], startPnt[1], endPnt[0], endPnt[1]);
//   //   double remainingDst = distanceFormula(reachPnt[0], reachPnt[1], endPnt[0], endPnt[1]);

//   //   return 1 - (remainingDst / totalDst);
//   // }

//   Set<Polyline> _getPolyLines(Iterable dataPoints) {
//     Set<Polyline> mapPolyLines = Set<Polyline>();

//     mapPolyLines.add(Polyline(
//       polylineId: PolylineId("line"),
//       // color: FuzSingleton().defaultColor,
//       points: pnts,
//       width: 5,
//       jointType: JointType.round,
//       endCap: Cap.roundCap,
//       startCap: Cap.roundCap,
//     ));
//     return mapPolyLines;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: databaseReference.child('coords').orderByKey().onValue,
//       builder: (context, AsyncSnapshot<Event> snapData) {
//         if (snapData.data == null) {
//           return Center(child: CircularProgressIndicator());
//         }

//         pnts.clear();

//         List<Pnt> tmpPnts = [];
//         for (var pnt in snapData.data.snapshot.value.entries) {
//           tmpPnts.add(Pnt(pnt.key, pnt.value['lat'], pnt.value['lng']));
//         }
//         tmpPnts.sort();
//         pnts.add(FuzSingleton().startPnt);
//         for (var pnt in tmpPnts) {
//           pnts.add(LatLng(pnt.lat, pnt.lng));
//         }

//         return Stack(
//           children: [
//             GoogleMap(
//               onMapCreated: _onMapCreated,
//               rotateGesturesEnabled: true,
//               initialCameraPosition: CameraPosition(
//                 target: _center,
//                 zoom: 3.5,
//               ),
//               polylines: _getPolyLines(snapData.data.snapshot.value.entries),
//               markers: _getMapMarkers(),
//             ),
//             SafeArea(child: MapProgressBar(_getRemainingDistence()))
//           ],
//         );
//       },
//     );
//   }
// }
