import 'package:call_mechanic/ShowMap.dart';
import 'package:call_mechanic/ForgotPassword.dart';
import 'package:flutter/material.dart';

class Customer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CustomerUI();
  }
}

myAlertDialog(context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Expanded(
            child: AlertDialog(
          title: Text('Alert !'),
          content: Text('Do you want to Log out?'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForgotPassword()));
                },
                child: Text('Yes')),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('No')),
          ],
        ));
      });
}

class CustomerUI extends State<Customer> {
  int curIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "App Name",
          style: TextStyle(color: Colors.amber.shade400),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(0),
              child: Row(
                children: [
                  Expanded(
                    flex: 35,
                    child: Text(
                      'Need A Mechanic?',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 65,
                    child: Image.asset('images/banner.png'),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerLeft, // Align the button to the left
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ShowMap()));
                },
                child: Text(
                  'Find One',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(0),
                    minimumSize: Size(90, 38),
                    backgroundColor: Colors.amber.shade400),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.amber.shade400,
        currentIndex: curIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
        onTap: (int index) {
          setState(() {
            curIndex = index;
          });
        },
      ),
    );
  }
}
