import 'package:flutter/material.dart';

class MechanicHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MechanicHomeUI();
  }
}

class Customer {
  final String name;
  final String location;

  Customer({
    required this.name,
    required this.location,
  });
}

class MechanicHomeUI extends State<MechanicHome> {
  bool isOnline = true;
  List<Customer> messages = [
    Customer(name: 'Alice', location: 'Akhalia'),
    Customer(name: 'Bob', location: 'Ambarkhana'),
    Customer(name: 'Alice', location: 'Akhalia'),
    Customer(name: 'Bob', location: 'Ambarkhana'),
    Customer(name: 'Alice', location: 'Akhalia'),
    Customer(name: 'Bob', location: 'Ambarkhana'),
    Customer(name: 'Alice', location: 'Akhalia'),
    Customer(name: 'Bob', location: 'Ambarkhana'),
    Customer(name: 'Alice', location: 'Akhalia'),
    Customer(name: 'Bob', location: 'Ambarkhana'),
    Customer(name: 'Alice', location: 'Akhalia'),
    Customer(name: 'Bob', location: 'Ambarkhana'),
    // Add more customers
  ];

  @override
  Widget build(BuildContext context) {
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
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
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                  decoration: BoxDecoration(
                    color: darkTheme
                        ? Color.fromRGBO(112, 112, 112, 1)
                        : Color.fromRGBO(236, 235, 235, 1),
                    borderRadius: BorderRadius.circular(
                        10), // Adjust the radius as needed
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: Colors.grey.withOpacity(0.5),
                    //     spreadRadius: 2,
                    //     blurRadius: 5,
                    //     offset: Offset(0, 3),
                    //   ),
                    // ],
                  ),
                  child: ListTile(
                    leading: CircleAvatar(child: Icon(Icons.person_sharp)),
                    title: Text(message.name),
                    subtitle: Text(message.location),
                    trailing: Icon(Icons.phone),
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
