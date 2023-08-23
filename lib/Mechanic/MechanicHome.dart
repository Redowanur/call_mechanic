import 'package:call_mechanic/ShowMap.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class MechanicHome extends StatefulWidget {
  String id;

  MechanicHome(this.id, {super.key});

  @override
  State<StatefulWidget> createState() {
    return MechanicHomeUI();
  }
}

class Customer {
  final String name;
  final String status;

  Customer({
    required this.name,
    required this.status,
  });
}

class MechanicHomeUI extends State<MechanicHome> {
  bool isOnline = true;
  List<Customer> customers = [
    Customer(name: 'Alice', status: 'Accepted'),
    Customer(name: 'Bob', status: 'Pending'),
    Customer(name: 'Alice', status: 'Accepted'),
    Customer(name: 'Bob', status: 'Accepted'),
    Customer(name: 'Alice', status: 'Pending'),
    // Add more customers
  ];

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
              content: Text('Do you want to accept request?'),
              actions: [
                TextButton(
                    onPressed: () {
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
                      myAlertDialog(context);
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
                          onPressed: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => ShowMap()),
                            // );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.phone),
                          onPressed: () async {
                            final Uri url =
                                Uri(scheme: 'tel', path: '01521783854');

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
