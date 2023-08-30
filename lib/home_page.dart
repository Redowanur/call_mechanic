import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageUI();
  }
}

class HomePageUI extends State<HomePage> {
  final int numberOfRows = 4;
  List<String> array = [
    'Tires',
    'Brakes Repair',
    'Oil Change',
    'Windshield',
    'A/C Repair',
    'Batteries'
  ];

  @override
  void initState() {
    super.initState();
    fetch();
  }

  fetch() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('services')
        .doc('ourservice')
        .get();

    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

      if (data.containsKey('service')) {
        dynamic array = data['service'];
        if (array is List<dynamic>) {
          for (String i in array) {
            print('--------------------------');
            print(i);
          }
        }
      } else {
        print("Array field not found");
      }
    } else {
      print("Document does not exist");
    }
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Available Services',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'UberMove',
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of cards in each row
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 20,
                ),
                itemCount:
                    array.length, // Total number of cards based on array length
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 4,
                    color: darkTheme
                        ? Color.fromRGBO(112, 112, 112, 1)
                        : Color.fromRGBO(248, 247, 247, 1),
                    child: Column(
                      children: [
                        Container(
                          height: 100, // Height of the image section
                          child: Image.asset(
                              'images/banner.png'), // Replace with your image
                        ),
                        SizedBox(height: 10),
                        Text(
                          array[index],
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'UberMove',
                              color: darkTheme
                                  ? Colors.amber.shade400
                                  : Colors.blue),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "\$1600",
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'UberMove',
                              color: darkTheme ? Colors.white : Colors.black),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => LoginScreen()));
                },
                child: Text('Sign In'),
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(0),
                    minimumSize: Size(90, 38),
                    backgroundColor:
                        darkTheme ? Colors.amber.shade400 : Colors.blue),
              ),
            ),
            SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}
