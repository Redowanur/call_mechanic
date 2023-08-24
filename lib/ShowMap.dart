import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class ShowMap extends StatefulWidget {
  String id, name1, phone1;
  // double latitude, longitude;
  ShowMap(this.id, this.name1, this.phone1);

  @override
  State<StatefulWidget> createState() {
    return ShowMapUI(id, name1, phone1);
  }
}

class ShowMapUI extends State<ShowMap> {
  bool isButtonEnabled = true;
  // double latitude, longitude;
  String id, name1, phone1;
  ShowMapUI(this.id, this.name1, this.phone1);

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

  Future<List<Map<String, dynamic>>> fetchOnlineMechanics() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    List<Map<String, dynamic>> users = querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();

    List<Map<String, dynamic>> onlineMechanics = users
        .where((user) => user['role'] == 'Mechanic' && user['isOnline'] == true)
        .toList();

    return onlineMechanics;
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
    fetchAndDisplayOnlineMechanics();
  }

  TextStyle infoStyle() {
    return TextStyle(
        fontFamily: 'UberMove', color: Color.fromRGBO(0, 103, 204, 1));
  }

  Future<void> foo(String id1) async {
    final CollectionReference users =
        FirebaseFirestore.instance.collection('users');
    Position position = await _determinePosition();
    Map<String, dynamic> newRequestForMechanic = {
      'name': name1,
      'phone': phone1,
      'latitude': position.latitude,
      'longitude': position.longitude,
      'status': 'Pending',
    };
    await users.doc(id1).update({
      'requests': FieldValue.arrayUnion([newRequestForMechanic]),
    });
  }

  Future _displayMechanicInfo(
      BuildContext context,
      String id1,
      String name,
      String phone,
      String address,
      String rating,
      double latitude,
      double longitude) {
    return showModalBottomSheet(
        context: context,
        backgroundColor: Color.fromRGBO(200, 235, 235, 1),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        builder: (context) => Container(
              height: 350,
              child: ListView(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  ListTile(
                    title: Text(
                      name,
                      style: infoStyle(),
                    ),
                    leading: Icon(
                      Icons.person,
                      color: Color.fromRGBO(0, 103, 204, 1),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      phone,
                      style: infoStyle(),
                    ),
                    leading: Icon(
                      Icons.phone,
                      color: Color.fromRGBO(0, 103, 204, 1),
                    ),
                    onTap: () async {
                      final Uri url = Uri(scheme: 'tel', path: phone);

                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      } else {
                        await Fluttertoast.showToast(
                            msg: 'Cannot find the phone number');
                      }
                    },
                  ),
                  ListTile(
                    title: Text(
                      address,
                      style: infoStyle(),
                    ),
                    leading: Icon(
                      Icons.location_on_outlined,
                      color: Color.fromRGBO(0, 103, 204, 1),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      rating,
                      style: infoStyle(),
                    ),
                    leading: Icon(
                      Icons.reviews,
                      color: Color.fromRGBO(0, 103, 204, 1),
                    ),
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: isButtonEnabled
                          ? () async {
                              try {
                                final CollectionReference users =
                                    FirebaseFirestore.instance
                                        .collection('users');

                                // Create the new request map
                                Map<String, dynamic> newRequest = {
                                  'id': id1,
                                  'name': name,
                                  'phone': phone,
                                  'latitude': latitude,
                                  'longitude': longitude,
                                  'status': 'Pending',
                                };
                                // Update the document with the new request
                                await users.doc(id).update({
                                  'requests':
                                      FieldValue.arrayUnion([newRequest]),
                                });
                                foo(id1);
                                Fluttertoast.showToast(
                                    msg: "Requested Service");
                              } catch (error) {
                                print('Error: $error');
                                // Handle error
                              }
                              setState(() {
                                isButtonEnabled = false;
                              });
                            }
                          : null,
                      child: Text(
                        'Request Service',
                        style: TextStyle(
                            fontFamily: 'UberMove', color: Colors.white),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromRGBO(
                                0, 103, 204, 1)), // Change this color
                      ),
                    ),
                  )
                ],
              ),
            ));
  }

  Future<void> fetchAndDisplayOnlineMechanics() async {
    List<Map<String, dynamic>> onlineMechanics = await fetchOnlineMechanics();

    setState(() {
      markers.addAll(onlineMechanics.map((user) {
        double latitude = user['latitude'] as double;
        double longitude = user['longitude'] as double;

        return Marker(
            markerId: MarkerId(user['id']), // Replace with a unique ID
            position: LatLng(latitude, longitude),
            onTap: () {
              _displayMechanicInfo(
                  context,
                  user['id'],
                  user['name'],
                  user['phone'],
                  user['address'],
                  user['rating'].toString(),
                  latitude,
                  longitude);
            });
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
}
