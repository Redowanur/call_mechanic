import 'package:call_mechanic/Admin/AddServices.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  @override
  Widget build(BuildContext context) {
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: ListView(
          padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
          children: [
            Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Text(
                  "Admin Panel",
                  style: TextStyle(
                    color: darkTheme ? Colors.amber.shade300 : Colors.blue,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'UberMove',
                  ),
                ),
                Padding(padding: EdgeInsets.fromLTRB(0, 100, 0, 0)),
                SizedBox(
                  height: 20,
                ),
                // Add a clickable card here
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (c) => AddServices()));
                  },
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
                          Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
                          SizedBox(
                            height: 15,
                          ),
                          Icon(
                            Icons
                                .add, // You can change the icon to your preference
                            color:
                                Colors.blue, // Change the icon color as needed
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Add More Services', // Replace with your card title
                            style: TextStyle(
                              fontFamily: 'UberMove',
                              color: Colors
                                  .blue, // Change the text color as needed
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
