import 'package:call_mechanic/MechanicProfile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'MechanicHome.dart';

class MechanicPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MechanicPageUI();
  }
}

class MechanicPageUI extends State<MechanicPage> {
  int curIndex = 0;

  List pages = [
    MechanicHome(),
    MechanicProfile(),
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
          selectedItemColor: darkTheme ? Colors.amber.shade400 : Colors.blue,
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
