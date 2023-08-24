import 'dart:async';
import 'package:location/location.dart' as loc;
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' show cos, sqrt, asin;

class Navigate2Customer extends StatefulWidget {
  final double srclat, srclong, destlat, destlong;

  Navigate2Customer(this.srclat, this.srclong, this.destlat, this.destlong,
      {Key? key})
      : super(key: key);

  @override
  State<Navigate2Customer> createState() => _Navigate2CustomerState();
}

class _Navigate2CustomerState extends State<Navigate2Customer> {
  final Completer<GoogleMapController?> _controller = Completer();
  Map<PolylineId, Polyline> polylines = {};
  PolylinePoints polylinePoints = PolylinePoints();
  Location location = Location();
  Marker? sourcePosition, destinationPosition;
  LatLng curLocation = LatLng(0.0, 0.0);

  @override
  void initState() {
    super.initState();
    curLocation = LatLng(widget.srclat, widget.srclong);
    getNavigation();
    setMarkers();
  }

  getNavigation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    final GoogleMapController? controller = await _controller.future;
    location.changeSettings(accuracy: LocationAccuracy.high);
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted == PermissionStatus.granted) {
        return;
      }
    }
    if (_permissionGranted == PermissionStatus.granted) {
      final _currentPosition = await location.getLocation();
      curLocation =
          LatLng(_currentPosition.latitude!, _currentPosition.longitude!);
      location.onLocationChanged.listen((LocationData currentLocation) {
        controller?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(currentLocation.latitude!, currentLocation.longitude!),
          zoom: 16,
        )));
        if (mounted) {
          setState(() {
            curLocation =
                LatLng(currentLocation.latitude!, currentLocation.longitude!);
            sourcePosition = Marker(
              markerId: MarkerId(curLocation.toString()),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueAzure),
              position:
                  LatLng(currentLocation.latitude!, currentLocation.longitude!),
              infoWindow: InfoWindow(
                title: double.parse(
                        (getDistance(LatLng(widget.destlat, widget.destlong))
                            .toStringAsFixed(2)))
                    .toString(),
              ),
              onTap: () {
                print("Marker tapped");
              },
            );
          });
          getDirections(LatLng(widget.destlat, widget.destlong));
        }
      });
    }
  }

  getDirections(LatLng dest) async {
    List<LatLng> polylineCoordinates = [];
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyDRVfwknu5mLR7plvtuOtle3a7gOUCywi0",
      PointLatLng(curLocation.latitude, curLocation.longitude),
      PointLatLng(dest.latitude, dest.longitude),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    addPolyline(polylineCoordinates);
  }

  addPolyline(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red.shade400,
      points: polylineCoordinates,
      width: 3,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  double calculateDistance(srclt, srcln, dstlt, dstln) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((dstlt - srclt) * p) / 2 +
        c(srclt * p) * c(dstlt * p) * (1 - c((dstln - srcln) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  getDistance(LatLng destLocation) {
    return calculateDistance(curLocation.latitude, curLocation.longitude,
        destLocation.latitude, destLocation.longitude);
  }

  setMarkers() {
    setState(() {
      sourcePosition = Marker(
        markerId: MarkerId("source/mechanic"),
        position: curLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      );
      destinationPosition = Marker(
        markerId: MarkerId("destination/customer"),
        position: LatLng(widget.destlat, widget.destlong),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: sourcePosition == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                GoogleMap(
                  zoomControlsEnabled: false,
                  polylines: Set<Polyline>.of(polylines.values),
                  initialCameraPosition:
                      CameraPosition(target: curLocation, zoom: 16),
                  markers: {sourcePosition!, destinationPosition!},
                  onTap: (LatLng) {},
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.blue),
                    child: IconButton(
                      icon: Icon(
                        Icons.navigation,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        await launchUrl(Uri.parse(
                            'google.navigation:q=${widget.destlat},${widget.destlong}'));
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
