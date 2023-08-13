import 'SignIn.dart';
import 'SignUp.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WelcomePageUI();
  }
}

class WelcomePageUI extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey,
          toolbarHeight: 180,
          elevation: 0,
          bottom: TabBar(
            labelColor: Colors.black,
            isScrollable: true,
            tabs: [
              Container(
                width: MediaQuery.of(context).size.width / 3,
                child: Tab(text: 'Sign In'),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 3,
                child: Tab(text: 'Sign Up'),
              ),
            ],
          ),
          flexibleSpace: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'images/spanner.png',
                  height: 90,
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 15, 0, 30),
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    'App Name',
                    style: TextStyle(
                      fontSize: 30, // Adjust the font size as needed
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Set the text color to white
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            SignIn(),
            SignUp(),
          ],
        ),
      ),
    );
  }
}
