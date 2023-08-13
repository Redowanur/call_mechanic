import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShowMap extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ShowMapUI();
  }
}

class ShowMapUI extends State<ShowMap> {
  static final CameraPosition kGooglePlex = const CameraPosition(
    target: LatLng(24.913099, 91.843737),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: kGooglePlex,
      ),
    );
  }
}
