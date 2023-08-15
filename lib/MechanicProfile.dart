import 'package:flutter/material.dart';

class MechanicProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MechanicProfileUI();
  }
}

class MechanicProfileUI extends State<MechanicProfile> {

  @override
  Widget build(BuildContext context) {
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
        
    return Container(
      padding: EdgeInsets.all(20),

    );
  }
}
