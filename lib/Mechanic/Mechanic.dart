import 'package:call_mechanic/Mechanic/MechanicProfile.dart';
import 'package:call_mechanic/Mechanic/MechanicSettings.dart';
import 'package:call_mechanic/ShowMap.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'MechanicHome.dart';

class Mechanic extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MechanicUI();
  }
}

class MechanicUI extends State<Mechanic> {
  int curIndex = 0;

  List pages = [
    MechanicHome(),
    ShowMap(),
    MechanicProfile(),
    MechanicSettings(),
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
            BottomNavigationBarItem(
                icon: Icon(Icons.location_pin), label: 'Map'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: 'Settings'),
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
