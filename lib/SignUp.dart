import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignUpUI();
  }
}

class SignUpUI extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Full Name')),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Username')),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Email')),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Password')),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: () {},
              child: Text('Sign Up'),
            ),
          ),
        ],
      ),
    );
  }
}
