import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

import '../navigation.dart';
import '../models/customer_data.dart';
import '../models/mechanic_data.dart';

// ignore: must_be_immutable
class MechanicHome extends StatefulWidget {
  String id;

  MechanicHome(this.id, {super.key});

  @override
  State<StatefulWidget> createState() {
    return MechanicHomeUI(id);
  }
}

class Customer {
  final String id;
  final String name;
  final String status;
  final String phone;
  final double latitude, longitude;

  Customer(
      {required this.id,
      required this.name,
      required this.status,
      required this.phone,
      required this.latitude,
      required this.longitude});
}

class MechanicHomeUI extends State<MechanicHome> {
  String id;
  bool isOnline = true;
  List<Customer> customers = [];
  MechanicHomeUI(this.id);

  @override
  void initState() {
    id = widget.id;
    fetchCustomersData();
  }

  fetchCustomersData() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('CustomerRequests')
        .doc(id)
        .get();

    if (snapshot.exists) {
      Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;

      if (userData.containsKey('idArray')) {
        dynamic arrayData = userData['idArray'];
        if (arrayData is List<dynamic>) {
          for (String i in arrayData) {
            String ii = i.substring(0, i.length - 1);
            String status = i.substring(i.length - 1);
            var cust = await CustomerModel.fetchCustomerData(ii);

            if (status == '0') {
              status = 'Pending';
            } else if (status == '1') {
              status = 'Accepted';
            }

            Customer customer = Customer(
              id: ii,
              name: cust.name,
              status: status,
              phone: cust.phone,
              latitude: cust.latitude,
              longitude: cust.longitude,
            );
            print(customer);
            setState(() {
              customers.add(customer);
            });
          }
        }
      }

      setState(() {}); // Trigger a UI update after fetching data
    } else {
      print('Document does not exist');
    }
  }

  Future<void> deleteCustomerData(Customer customer) async {
    try {
      await FirebaseFirestore.instance
          .collection('MechanicRequests')
          .doc(customer.id) // customer's id
          .update({
        'id1Array': FieldValue.arrayRemove([id + '1', id + '0']),
      });
      // Step 2: Delete the mechanic data from the customer's table
      await FirebaseFirestore.instance
          .collection('CustomerRequests')
          .doc(id) // customer's id
          .update({
        'idArray':
            FieldValue.arrayRemove([customer.id + '1', customer.id + '0']),
      });

      setState(() {
        customers.remove(customer);
      });

      Fluttertoast.showToast(msg: 'Mechanic deleted successfully');
    } catch (error) {
      Fluttertoast.showToast(msg: 'Failed to delete mechanic');
      print('Error: $error');
    }
  }

  Future<void> acceptRequest(String customerId) async {
    try {
      await FirebaseFirestore.instance
          .collection('CustomerRequests')
          .doc(id)
          .update({
        'idArray': FieldValue.arrayRemove([customerId + '0']),
      });

      String temp = customerId + '1';
      await FirebaseFirestore.instance
          .collection('CustomerRequests')
          .doc(id)
          .update({
        'idArray': FieldValue.arrayUnion([temp]),
      });

      await FirebaseFirestore.instance
          .collection('MechanicRequests')
          .doc(customerId)
          .update({
        'id1Array': FieldValue.arrayRemove([id + '0']),
      });

      temp = id + '1';
      await FirebaseFirestore.instance
          .collection('MechanicRequests')
          .doc(customerId)
          .update({
        'id1Array': FieldValue.arrayUnion([temp]),
      });

      Fluttertoast.showToast(msg: 'Request accepted successfully');
    } catch (error) {
      Fluttertoast.showToast(msg: 'Failed to accept request');
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    myAlertDialog(context, Customer customer) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return Expanded(
                child: AlertDialog(
              // title: Text('Alert !'),
              content: Text('Do you want to accept request?'),
              actions: [
                TextButton(
                    onPressed: () {
                      acceptRequest(customer.id);
                      Navigator.of(context).pop();
                      Fluttertoast.showToast(msg: "Accepted Request");
                    },
                    child: Text(
                      'Accept',
                      style: TextStyle(
                        fontFamily: 'UberMove',
                        color: darkTheme ? Colors.amber.shade300 : Colors.blue,
                      ),
                    )),
                TextButton(
                    onPressed: () {
                      deleteCustomerData(customer);
                      Navigator.of(context).pop();
                      Fluttertoast.showToast(msg: "Deleted Request");
                    },
                    child: Text(
                      'Delete',
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
      padding: EdgeInsets.all(20),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1st children
          Container(
            alignment: Alignment.topLeft,
            child: Text(
              'Appointments',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                fontFamily: 'UberMove',
                color: darkTheme ? Colors.amber.shade300 : Colors.blue,
              ),
            ),
          ),
          // 2nd children
          SizedBox(
            height: 20,
          ),
          // 3rd children
          Expanded(
            child: ListView.builder(
              itemCount: customers.length,
              itemBuilder: (context, index) {
                final customer = customers[index];
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                  decoration: BoxDecoration(
                    color: darkTheme
                        ? Color.fromRGBO(112, 112, 112, 1)
                        : Color.fromRGBO(236, 235, 235, 1),
                    borderRadius: BorderRadius.circular(
                        10), // Adjust the radius as needed
                  ),
                  child: ListTile(
                    onTap: () {
                      if (customer.status == 'Pending') {
                        myAlertDialog(context, customer);
                      } else if (customer.status == 'Accepted') {}
                    },
                    leading: CircleAvatar(child: Icon(Icons.person_sharp)),
                    title: Text(customer.name),
                    subtitle: Text(customer.status),
                    trailing: Row(
                      mainAxisSize: MainAxisSize
                          .min, // Adjust the size of the Row as needed
                      children: [
                        IconButton(
                          icon: Icon(Icons.location_pin),
                          onPressed: () async {
                            var mechanic =
                                await MechanicModel.fetchMechanicData(
                                    widget.id);
                            // ignore: use_build_context_synchronously
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Navigate2Customer(
                                  mechanic.latitude,
                                  mechanic.longitude,
                                  customer.latitude,
                                  customer.longitude,
                                ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.phone),
                          onPressed: () async {
                            final Uri url =
                                Uri(scheme: 'tel', path: customer.phone);

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
          )
        ],
      ),
    );
  }
}
