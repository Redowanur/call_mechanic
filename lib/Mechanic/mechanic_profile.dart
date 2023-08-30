import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'profdetails/SettingPage.dart';
import 'profdetails/HelpPage.dart'; // Import the HelpPage.dart file
import 'profdetails/BalancePage.dart'; // Import the BalancePage.dart file
import 'profdetails/ActivityPage.dart';
import '../login_screen.dart';

class MechanicProfile extends StatefulWidget {
  String id, name;
  bool isOnline;
  MechanicProfile(this.id, this.name, this.isOnline);

  @override
  State<StatefulWidget> createState() {
    return MechanicProfileUI(id, name, isOnline);
  }
}

class MechanicProfileUI extends State<MechanicProfile> {
  String id, name;
  bool isOnline;
  late GoogleMapController googleMapController;

  MechanicProfileUI(this.id, this.name, this.isOnline);

  final userDocRef = FirebaseFirestore.instance.collection('users');

  _launchPhone(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchEmail(String email) async {
    final Uri _emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
    );

    if (await canLaunch(_emailLaunchUri.toString())) {
      await launch(_emailLaunchUri.toString());
    } else {
      throw 'Could not launch email';
    }
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    myAlertDialog(context) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text('Do you want to Log out?'),
              actions: [
                TextButton(
                  child: Text(
                    'Yes',
                    style: TextStyle(
                      fontFamily: 'UberMove',
                      color: darkTheme ? Colors.amber.shade300 : Colors.blue,
                    ),
                  ),
                  onPressed: () async {
                    setState(() async {
                      isOnline = false;
                      if (!isOnline) {
                        await userDocRef.doc(id).update({
                          'isOnline': false,
                          'latitude': 0,
                          'longitude': 0,
                        });

                        Navigator.of(context).pop();
                        Navigator.push(context,
                            MaterialPageRoute(builder: (c) => LoginScreen()));
                        Fluttertoast.showToast(msg: "Logged out");
                      }
                    });
                  },
                ),
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
            );
          });
    }

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
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
                    ),
                  ),
                  const Expanded(
                    flex: 20,
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.blue, // Change the icon color as needed
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Icon(
                    Icons.star,
                    size: 15,
                    color: Colors
                        .amber.shade300, // Change the star color as needed
                  ),
                  SizedBox(
                    width: 15,
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
                      width:
                          0), // Add some space between the text and the switch
                  Switch(
                    value: isOnline,
                    onChanged: (value) async {
                      setState(() {
                        isOnline = value;
                      });

                      if (isOnline) {
                        Position position = await _determinePosition();
                        await userDocRef.doc(id).update({
                          'isOnline': true,
                          'latitude': position.latitude,
                          'longitude': position.longitude,
                        });
                      } else {
                        await userDocRef.doc(id).update({
                          'isOnline': false,
                          'latitude': 0.0,
                          'longitude': 0.0,
                        });
                      }
                    },
                    activeColor:
                        darkTheme ? Colors.amber.shade300 : Colors.blue,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HelpPage()),
                        );
                      },
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
                              Icon(
                                Icons.help_sharp,
                                color: Colors
                                    .blue, // Change the icon color as needed
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Help',
                                style: TextStyle(
                                  fontFamily: 'UberMove',
                                  color: Colors
                                      .blue, // Change the text color as needed
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: SizedBox(width: 0),
                  ),
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BalancePage()),
                        );
                      },
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
                              Icon(
                                Icons.account_balance,
                                color: Colors
                                    .blue, // Change the icon color as needed
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Balance',
                                style: TextStyle(
                                  fontFamily: 'UberMove',
                                  color: Colors
                                      .blue, // Change the text color as needed
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: SizedBox(width: 0),
                  ),
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ActivityPage()),
                        );
                      },
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
                              Icon(
                                Icons.local_activity,
                                color: Colors
                                    .blue, // Change the icon color as needed
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Activity',
                                style: TextStyle(
                                  fontFamily: 'UberMove',
                                  color: Colors
                                      .blue, // Change the text color as needed
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingPage()),
                );
              },
              tileColor: darkTheme ? Colors.black : Colors.white,
              contentPadding: EdgeInsets.all(16.0),
              dense: true,
            ),
            ListTile(
              title: Text('Log out'),
              leading: Icon(Icons.logout),
              onTap: () {
                myAlertDialog(context);
              },
              tileColor: darkTheme
                  ? Colors.black
                  : Colors.white, // Change the tile color as needed
              contentPadding: EdgeInsets.all(16.0), // Add padding as needed
              dense: true, // To reduce the ListTile height
            ),
          ],
        ),
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
