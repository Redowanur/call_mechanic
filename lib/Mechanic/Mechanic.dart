import 'package:call_mechanic/Mechanic/MechanicProfile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'MechanicHome.dart';

// ignore: must_be_immutable
class Mechanic extends StatefulWidget {
  String id, name;
  bool isOnline;
  Mechanic(this.id, this.name, this.isOnline, {super.key});

  @override
  State<StatefulWidget> createState() {
    return MechanicUI(id, name, isOnline);
  }
}

class MechanicUI extends State<Mechanic> {
  String id, name;
  bool isOnline;
  int curIndex = 0;

  MechanicUI(this.id, this.name, this.isOnline);

  @override
  Widget build(BuildContext context) {
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    List pages = [
      MechanicHome(id),
      MechanicProfile(id, name, isOnline),
      // MechanicSettings(),
    ];

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
