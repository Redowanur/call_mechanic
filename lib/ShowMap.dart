import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_info_window/custom_info_window.dart';

class ShowMap extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ShowMapUI();
  }
}

class ShowMapUI extends State<ShowMap> {
  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  Set<Marker> markers = {};
  late GoogleMapController googleMapController;

  @override
  void dispose() {
    googleMapController.dispose();
    super.dispose();
  }

  static const LatLng sourceLocation = LatLng(24.897063, 91.869985);
  static const LatLng destination = LatLng(37.33429383, -122.06600055);

  List<LatLng> polylineCoordinates = [];

  Future<List<Map<String, dynamic>>> fetchOnlineUsers() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    List<Map<String, dynamic>> users = querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();

    List<Map<String, dynamic>> onlineUsers =
        users.where((user) => user['isOnline'] == true).toList();

    return onlineUsers;
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyCEmdYDO54KNvyFJCRx0P4GcCGiwR0OLYA',
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );

    if (result.points.isNotEmpty) {
      result.points.forEach(
        (PointLatLng point) =>
            polylineCoordinates.add(LatLng(point.latitude, point.longitude)),
      );
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getPolyPoints();
    fetchAndDisplayOnlineUsers();
  }

  Widget _buildInfoWindowContent(Map<String, dynamic> user) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text('User Info', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Text('Name: ${user['name']}'),
        Text('Phone: ${user['phone']}'),
        Text('Rating: ${user['rating']}'),
      ],
    );
  }

  Future<void> fetchAndDisplayOnlineUsers() async {
    List<Map<String, dynamic>> onlineUsers = await fetchOnlineUsers();

    setState(() {
      markers.addAll(onlineUsers.map((user) {
        GeoPoint location = user['location'] as GeoPoint;
        // print(user['location']);
        return Marker(
          markerId: MarkerId(user['id']), // Replace with a unique ID
          position: LatLng(location.latitude, location.longitude),
        );
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    // Example: Changing the marker color to red
    BitmapDescriptor customMarker =
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);

    return Scaffold(
      body: GoogleMap(
        initialCameraPosition:
            CameraPosition(target: sourceLocation, zoom: 13.5),
        polylines: {
          Polyline(
            polylineId: PolylineId('route'),
            points: polylineCoordinates,
            color: Colors.blue,
            width: 6,
          )
        },
        markers: markers,
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller) {
          googleMapController = controller;
        },
        zoomControlsEnabled: false,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () async {
          Position position = await _determinePosition();
          googleMapController.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(
                  target: LatLng(position.latitude, position.longitude),
                  zoom: 14)));

          markers.add(Marker(
              markerId: const MarkerId('currentLocation'),
              position: LatLng(position.latitude, position.longitude),
              icon: customMarker));

          setState(() {});
        },
        child: Icon(Icons.my_location),
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error('Location permission denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    Position position = await Geolocator.getCurrentPosition();

    return position;
  }

  foo() {
    print('objection your honor');
  }
}
