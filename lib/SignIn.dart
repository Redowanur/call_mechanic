import 'package:call_mechanic/CustomerPage.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignInUI();
  }
}

class SignInUI extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(40, 50, 40, 40),
            child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Username')),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(40, 0, 40, 20),
            child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Password')),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CustomerPage()));
              },
              child: Text('Sign In'),
            ),
          ),
        ],
      ),
    );
  }
}
