import 'package:flutter/material.dart';
import 'CustomerHome.dart';
import 'package:flutter/services.dart';
import 'CustomerProfile.dart';

class Customer extends StatefulWidget {
  String id, name;
  Customer(this.id, this.name, {super.key});

  @override
  State<StatefulWidget> createState() {
    return CustomerUI(id, name);
  }
}

class CustomerUI extends State<Customer> {
  String id, name;
  int curIndex = 0;

  CustomerUI(this.id, this.name);

  List pages = [
    CustomerHome(),
    CustomerProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: darkTheme
          ? Color.fromRGBO(66, 66, 66, 1)
          : Colors.white, // Replace with your desired color
    ));

    return SafeArea(
      child: Scaffold(
        body: pages[curIndex],
        extendBody: true,
        bottomNavigationBar: BottomNavigationBar(
          selectedLabelStyle: TextStyle(fontFamily: 'UberMove'),
          selectedItemColor: darkTheme ? Colors.amber.shade400 : Colors.blue,
          unselectedItemColor: darkTheme
              ? Color.fromRGBO(191, 178, 175, 1)
              : Color.fromRGBO(168, 168, 168, 1),
          currentIndex: curIndex,
          showSelectedLabels: true,
          showUnselectedLabels: false,
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
      ),
    );
  }
}