import 'package:call_mechanic/LoginScreen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MechanicProfile extends StatefulWidget {
  String id, name;
  MechanicProfile(this.id, this.name);

  @override
  State<StatefulWidget> createState() {
    return MechanicProfileUI(id, name);
  }
}

class MechanicProfileUI extends State<MechanicProfile> {
  String id, name;
  bool isOnline = true;
  late GoogleMapController googleMapController;

  MechanicProfileUI(this.id, this.name);

  final ref = FirebaseDatabase.instance.ref('users');

  @override
  Widget build(BuildContext context) {
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    myAlertDialog(context) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return Expanded(
                child: AlertDialog(
              // title: Text('Alert !'),
              content: Text('Do you want to Log out?'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (c) => LoginScreen()));
                      Fluttertoast.showToast(msg: "Logged out");
                    },
                    child: Text(
                      'Yes',
                      style: TextStyle(
                        fontFamily: 'UberMove',
                        color: darkTheme ? Colors.amber.shade300 : Colors.blue,
                      ),
                    )),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'No',
                      style: TextStyle(
                        fontFamily: 'UberMove',
                        color: darkTheme ? Colors.amber.shade300 : Colors.blue,
                      ),
                    )),
              ],
            ));
          });
    }

    return Container(
      padding: const EdgeInsets.all(0),
      child: Column(children: [
        // 1st children
        Container(
          // alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                  flex: 80,
                  child: Text(
                    name,
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'UberMove',
                      color: darkTheme ? Colors.amber.shade300 : Colors.blue,
                    ),
                  )),
              const Expanded(
                  flex: 20,
                  child: Icon(
                    Icons.person,
                    size: 60,
                  )),
            ],
          ),
        ),
        // 2nd children
        Container(
          padding: const EdgeInsets.all(20),
          child: const Row(
            children: [
              Icon(
                Icons.star,
                size: 15,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                '5.0',
                style: TextStyle(fontSize: 15, fontFamily: 'UberMove'),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
          child: Row(
            children: [
              Text(
                'Online:',
                style: TextStyle(
                  fontFamily: 'UberMove',
                  fontSize: 16,
                  color: darkTheme ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(
                  width: 0), // Add some space between the text and the switch
              Switch(
                value: isOnline,
                onChanged: (value) {
                  setState(() async {
                    isOnline = value;
                    if (isOnline) {
                      Position position = await _determinePosition();
                      ref.child(id).update({
                        'isOnline': true,
                        'latitude': position.latitude,
                        'longitude': position.longitude,
                      });

                      setState(() {});
                    } else {
                      ref.child(id).update({
                        'isOnline': false,
                        'latitude': 0.0,
                        'longitude': 0.0,
                      });

                      setState(() {});
                    }
                  });
                },
                activeColor: darkTheme
                    ? Colors.amber.shade300
                    : Colors.blue, // Change the active color
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
          child: Row(
            children: [
              Expanded(
                  flex: 30,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 2,
                    color: darkTheme
                        ? Color.fromRGBO(112, 112, 112, 1)
                        : Color.fromRGBO(248, 247, 247, 1),
                    child: const Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          Icon(Icons.help_sharp),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Help',
                            style: TextStyle(fontFamily: 'UberMove'),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                  )),
              Expanded(
                flex: 5,
                child: SizedBox(width: 0),
              ),
              Expanded(
                  flex: 30,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 2,
                    color: darkTheme
                        ? Color.fromRGBO(112, 112, 112, 1)
                        : Color.fromRGBO(248, 247, 247, 1),
                    child: const Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          Icon(Icons.account_balance),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Balance',
                            style: TextStyle(fontFamily: 'UberMove'),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                  )),
              Expanded(
                flex: 5,
                child: SizedBox(width: 0),
              ),
              Expanded(
                  flex: 30,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 2,
                    color: darkTheme
                        ? Color.fromRGBO(112, 112, 112, 1)
                        : Color.fromRGBO(248, 247, 247, 1),
                    child: const Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          Icon(Icons.local_activity),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Activity',
                            style: TextStyle(fontFamily: 'UberMove'),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                  )),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 6,
          color: darkTheme
              ? Color.fromRGBO(112, 112, 112, 1)
              : Color.fromRGBO(236, 235, 235, 1),
        ),
        SizedBox(
          height: 15,
        ),
        ListTile(
          title: Text('Settings'),
          leading: Icon(Icons.settings),
          onTap: () {
            // mySnackBar('Home', context);
          },
          iconColor: darkTheme ? Colors.amber.shade300 : Colors.blue,
        ),
        ListTile(
          title: Text('Log out'),
          leading: Icon(Icons.logout),
          onTap: () {
            myAlertDialog(context);
          },
          iconColor: darkTheme ? Colors.amber.shade300 : Colors.blue,
        ),
      ]),
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
