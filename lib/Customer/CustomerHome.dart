import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:call_mechanic/ShowMap.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

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
  final double latitude, longitude;

  Mechanic(
      {required this.id,
      required this.name,
      required this.status,
      required this.phone,
      required this.latitude,
      required this.longitude});
}

class CustomerHomeUI extends State<CustomerHome> {
  String id, name, phone;
  // double latitude, longitude;
  bool shouldRefresh = false;
  List<Mechanic> mechanics = [];
  CustomerHomeUI(this.id, this.name, this.phone);

  @override
  void initState() {
    super.initState();
    id = widget.id;
    name = widget.name;
    phone = widget.phone;
    fetchMechanicsData();
  }

  // Future<void> deleteMechanicData(Mechanic mechanic) async {
  //   try {
  //     Position position = await _determinePosition();
  //     // Step 1: Delete the customer data from the mechanic's table
  //     await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(mechanic.id) // mechanic's id
  //         .update({
  //       'requests': FieldValue.arrayRemove([
  //         {
  //           'name': name,
  //           'phone': phone,
  //           'latitude': position.latitude,
  //           'longitude': position.longitude,
  //           'status': mechanic.status,
  //         }
  //       ]),
  //     });

  //     // Step 2: Delete the mechanic data from the customer's table
  //     await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(id) // customer's id
  //         .update({
  //       'requests': FieldValue.arrayRemove([
  //         {
  //           'id': mechanic.id, // mechanic's id
  //           'name': mechanic.name,
  //           'phone': mechanic.phone,
  //           'latitude': mechanic.latitude,
  //           'longitude': mechanic.longitude,
  //           'status': mechanic.status,
  //         }
  //       ]),
  //     });

  //     // Update the local mechanics list
  //     setState(() {
  //       mechanics.remove(mechanic);
  //     });

  //     Fluttertoast.showToast(msg: 'Mechanic deleted successfully');
  //   } catch (error) {
  //     Fluttertoast.showToast(msg: 'Failed to delete mechanic');
  //     print('Error: $error');
  //   }
  // }

  fetchMechanicsData() async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').doc(id).get();

    if (snapshot.exists) {
      Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;

      List<Map<String, dynamic>> requestsData =
          List<Map<String, dynamic>>.from(userData['requests']);

      for (Map<String, dynamic> request in requestsData) {
        String id = request['id'];
        String name = request['name'];
        String phone = request['phone'];
        double latitude = request['latitude'];
        double longitude = request['longitude'];
        String status = request['status'];

        Mechanic mechanic = Mechanic(
          id: id,
          name: name,
          status: status,
          phone: phone,
          latitude: latitude,
          longitude: longitude,
        );

        mechanics.add(mechanic);
      }

      setState(() {}); // Trigger a UI update after fetching data
    } else {
      print('Document does not exist');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
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
                                        // deleteMechanicData(mechanic);
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
                            onPressed: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) => ShowMap(id)),
                              // );
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

  // Future<Position> _determinePosition() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();

  //   if (!serviceEnabled) {
  //     return Future.error('Location services are disabled.');
  //   }

  //   permission = await Geolocator.checkPermission();

  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();

  //     if (permission == LocationPermission.denied) {
  //       return Future.error('Location permission denied.');
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     return Future.error('Location permissions are permanently denied');
  //   }

  //   Position position = await Geolocator.getCurrentPosition();

  //   return position;
  // }
}
