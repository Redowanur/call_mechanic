import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:call_mechanic/navigator_for_customer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:call_mechanic/show_map.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/mechanic_data.dart';

// ignore: must_be_immutable
class CustomerHome extends StatefulWidget {
  String id, name, phone;
  // double latitude, longitude;
  CustomerHome(this.id, this.name, this.phone);

  @override
  State<StatefulWidget> createState() {
    return CustomerHomeUI(id, name, phone);
  }
}

class Mechanic {
  final String id;
  final String name;
  final String status;
  final String phone;
  final double latitude, longitude, rating;
  final int reviews;

  Mechanic({
    required this.id,
    required this.name,
    required this.status,
    required this.phone,
    required this.latitude,
    required this.longitude,
    required this.rating,
    required this.reviews,
  });
}

class CustomerHomeUI extends State<CustomerHome> {
  String id, name, phone;
  bool isChecked = false;
  // double latitude, longitude;
  bool shouldRefresh = false;
  List<Mechanic> mechanics = [];
  CustomerHomeUI(this.id, this.name, this.phone);

  final userDocRef = FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    AwesomeNotifications().initialize(
      'https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fi.pinimg.com%2Foriginals%2F2b%2Ffb%2F10%2F2bfb109966e64e9d6884d811a0072029.jpg&f=1&nofb=1&ipt=984cc268343124711e260f7eb8da34138a828e4565b39a82cd13e2078ce8d317&ipo=images', // Replace with your app icon resource
      [
        NotificationChannel(
          channelKey: 'Call Mechanic',
          channelName: 'Mechanic Status',
          channelDescription: 'Car Helper',
          defaultColor: Color(0xFF9D50DD),
          ledColor: Colors.white,
        ),
      ],
    );
    super.initState();
    AwesomeNotifications().isNotificationAllowed().then((isallowed) {
      if (!isallowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    super.initState();
    id = widget.id;
    name = widget.name;
    phone = widget.phone;
    fetchMechanicsData();
  }

  Future<void> deleteMechanicData(Mechanic mechanic) async {
    try {
      await FirebaseFirestore.instance
          .collection('MechanicRequests')
          .doc(id) // customer's id
          .update({
        'id1Array':
            FieldValue.arrayRemove([mechanic.id + '1', mechanic.id + '0']),
      });
      // Step 2: Delete the mechanic data from the customer's table
      await FirebaseFirestore.instance
          .collection('CustomerRequests')
          .doc(mechanic.id) // customer's id
          .update({
        'idArray': FieldValue.arrayRemove([id + '1', id + '0']),
      });

      setState(() {
        mechanics.remove(mechanic);
      });

      Fluttertoast.showToast(msg: 'Mechanic deleted successfully');
    } catch (error) {
      Fluttertoast.showToast(msg: 'Failed to delete mechanic');
      print('Error: $error');
    }
  }

  fetchMechanicsData() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('MechanicRequests')
        .doc(id)
        .get();

    if (snapshot.exists) {
      Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;

      if (userData.containsKey('id1Array')) {
        dynamic arrayData = userData['id1Array'];
        if (arrayData is List<dynamic>) {
          for (String i in arrayData) {
            String ii = i.substring(0, i.length - 1);
            String status = i.substring(i.length - 1);
            var mecha = await MechanicModel.fetchMechanicData(ii);

            if (status == '0') {
              status = 'Pending';
            } else if (status == '1') {
              status = 'Accepted';
            }

            Mechanic mechanic = Mechanic(
              id: ii,
              name: mecha.name,
              status: status,
              phone: mecha.phone,
              latitude: mecha.latitude,
              longitude: mecha.longitude,
              rating: mecha.rating,
              reviews: mecha.reviews,
            );
            // print('------------------------------------------------');
            // print(ii);
            // print(mecha.name);
            // print(status);
            // print(mecha.phone);
            // print(mecha.latitude);
            // print(mecha.longitude);
            mechanics.add(mechanic);
          }
        }
      }

      // setState(() {}); // Trigger a UI update after fetching data
    } else {
      print('Document does not exist');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    displayBottomSheet(
        BuildContext context, String mechanicId, int review, double curRating) {
      double rating = 0.0; // Default rating value

      showModalBottomSheet(
        context: context,
        backgroundColor: darkTheme
            ? const Color.fromARGB(255, 93, 92, 92)
            : Color.fromARGB(255, 220, 220, 220),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        builder: (context) => Container(
          padding: EdgeInsets.all(20),
          height: 300,
          child: ListView(
            children: [
              SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    Text(
                      'Thanks for using our service.',
                      style: TextStyle(fontSize: 17),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Would you like to rate the Mechanic?',
                      style: TextStyle(fontSize: 17),
                    ),
                    SizedBox(height: 20),
                    RatingBar.builder(
                      initialRating: rating,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 30,
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (newRating) {
                        setState(() {
                          rating = newRating;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        rating = ((curRating * review) + rating) / (review + 1);
                        review++;
                        await userDocRef.doc(mechanicId).update({
                          'rating': double.parse(rating.toStringAsFixed(1)),
                          'reviews': review,
                        });
                        Navigator.of(context).pop(); // Close the bottom sheet
                      },
                      child: Text('Submit Rating'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              darkTheme ? Colors.amber.shade400 : Colors.blue),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  Expanded(
                    flex: 35,
                    child: Text(
                      'Need A Mechanic?',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'UberMove',
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 65,
                    child: Image.asset('images/banner.png'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  20, 0, 20, 20), // Align the button to the left
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      shouldRefresh = !shouldRefresh;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ShowMap(id, name, phone)));
                    },
                    child: Text(
                      'Find One',
                      style: TextStyle(fontSize: 16, fontFamily: 'UberMove'),
                    ),
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(0),
                        minimumSize: Size(90, 38),
                        backgroundColor:
                            darkTheme ? Colors.amber.shade300 : Colors.blue),
                  ),
                ],
              ),
            ),
            Container(
              height: 6,
              color: darkTheme
                  ? Color.fromRGBO(112, 112, 112, 1)
                  : Color.fromRGBO(236, 235, 235, 1),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Row(
                children: [
                  Container(
                    child: Row(children: [
                      Text(
                        'Current Services',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'UberMove',
                        ),
                      ),
                    ]),
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: mechanics.length,
                itemBuilder: (context, index) {
                  final mechanic = mechanics[index];
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                    decoration: BoxDecoration(
                      color: darkTheme
                          ? Color.fromRGBO(112, 112, 112, 1)
                          : Color.fromRGBO(236, 235, 235, 1),
                      borderRadius: BorderRadius.circular(
                          10), // Adjust the radius as needed
                    ),
                    child: ListTile(
                      onTap: () {
                        if (mechanic.status == 'Pending') {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Confirm Deletion'),
                                content:
                                    Text('Do you want to cancel the request?'),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        deleteMechanicData(mechanic);
                                        Navigator.of(context).pop();
                                        Fluttertoast.showToast(
                                            msg: "Canceled Request");
                                      },
                                      child: Text(
                                        'Yes',
                                        style: TextStyle(
                                          fontFamily: 'UberMove',
                                          color: darkTheme
                                              ? Colors.amber.shade300
                                              : Colors.blue,
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
                                          color: darkTheme
                                              ? Colors.amber.shade300
                                              : Colors.blue,
                                        ),
                                      )),
                                ],
                              );
                            },
                          );
                        } else if (mechanic.status == 'Accepted') {
                          // AwesomeNotifications().createNotification(
                          //   content: NotificationContent(
                          //     id: 0,
                          //     channelKey: 'basic_channel',
                          //     title: 'Mechanic Status Update',
                          //     body: 'Your mechanic is on the way!',
                          //   ),
                          // );
                          displayBottomSheet(context, mechanic.id,
                              mechanic.reviews, mechanic.rating);
                        }
                      },
                      leading: CircleAvatar(child: Icon(Icons.person_sharp)),
                      title: Text(mechanic.name),
                      subtitle: Text(mechanic.status),
                      trailing: Row(
                        mainAxisSize: MainAxisSize
                            .min, // Adjust the size of the Row as needed
                        children: [
                          IconButton(
                            icon: Icon(Icons.location_pin),
                            onPressed: () async {
                              Position position = await _determinePosition();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ShowPolyline(
                                          24.911851,
                                          91.871593,
                                          position.latitude,
                                          position.longitude,
                                        )),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.phone),
                            onPressed: () async {
                              final Uri url =
                                  Uri(scheme: 'tel', path: mechanic.phone);

                              if (await canLaunchUrl(url)) {
                                await launchUrl(url);
                              } else {
                                await Fluttertoast.showToast(
                                    msg: 'Cannot find the phone number');
                              }
                            },
                            // splashColor: Colors.red,
                          ),
                        ],
                      ),
                      tileColor: Colors
                          .transparent, // Set to transparent to avoid overlapping with the container's background
                    ),
                  );
                },
              ),
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
