import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShowPolyline extends StatefulWidget {
  double srclat, srclong, destlat, destlong;
  ShowPolyline(this.srclat, this.srclong, this.destlat, this.destlong);
  @override
  State<StatefulWidget> createState() {
    return ShowPolylineUI(srclat, srclong, destlat, destlong);
  }
}

class ShowPolylineUI extends State<ShowPolyline> {
  double srclat, srclong, destlat, destlong;
  ShowPolylineUI(this.srclat, this.srclong, this.destlat, this.destlong);

  List<LatLng> polylineCoordinates = [];

  void getPolylinePoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyCEmdYDO54KNvyFJCRx0P4GcCGiwR0OLYA',
      PointLatLng(srclat, srclong),
      PointLatLng(destlat, destlong),
    );
    print('--------------------------------');
    print(result.points);

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) =>
          polylineCoordinates.add(LatLng(point.latitude, point.longitude)));
      setState(() {});
    }
  }

  @override
  void initState() {
    getPolylinePoints();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition:
            CameraPosition(target: LatLng(destlat, destlong), zoom: 13),
        polylines: {
          Polyline(
              polylineId: PolylineId('route'), points: polylineCoordinates),
        },
        markers: {
          Marker(
            markerId: MarkerId('source'),
            position: LatLng(srclat, srclong),
          ),
          Marker(
            markerId: MarkerId('destination'),
            position: LatLng(destlat, destlong),
          )
        },
        zoomControlsEnabled: false,
      ),
    );
  }
}
