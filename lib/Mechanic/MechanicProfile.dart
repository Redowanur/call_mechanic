import 'package:flutter/material.dart';

class MechanicProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MechanicProfileUI();
  }
}

class MechanicProfileUI extends State<MechanicProfile> {
  int _rating = 0;
  bool isOnline = true;

  @override
  Widget build(BuildContext context) {
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(0),
      child: Column(children: [
        // 1st children
        Container(
          // alignment: Alignment.topLeft,
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                  flex: 80,
                  child: Text(
                    'Redowanur Rahman',
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'UberMove',
                      color: darkTheme ? Colors.amber.shade300 : Colors.blue,
                    ),
                  )),
              Expanded(
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
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(
                Icons.star,
                size: 15,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                '5.0',
                style: TextStyle(fontSize: 15, fontFamily: 'UberMove'),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
          child: Row(
            children: [
              Text(
                'Online:',
                style: TextStyle(
                  fontFamily: 'UberMove',
                  fontSize: 16,
                  color: darkTheme ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(
                  width: 0), // Add some space between the text and the switch
              Switch(
                value: isOnline,
                onChanged: (value) {
                  setState(() {
                    isOnline = value;
                  });
                },
                activeColor: darkTheme
                    ? Colors.amber.shade300
                    : Colors.blue, // Change the active color
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 15),
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

        // Container(
        //   height: 8,
        //   color: darkTheme
        //       ? Color.fromRGBO(112, 112, 112, 1)
        //       : Color.fromRGBO(236, 235, 235, 1),
        // ),
        // SizedBox(
        //   height: 15,
        // ),
      ]),
    );
  }
}
