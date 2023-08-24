import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../LoginScreen.dart';

class CustomerProfile extends StatefulWidget {
  String id, name;

  CustomerProfile(this.id, this.name, {super.key});
  @override
  State<StatefulWidget> createState() {
    return CustomerProfileUI(id, name);
  }
}

class CustomerProfileUI extends State<CustomerProfile> {
  String id, name;
  CustomerProfileUI(this.id, this.name);

  final userDocRef = FirebaseFirestore.instance.collection('users');

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
}
