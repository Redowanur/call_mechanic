import 'package:firebase_database/firebase_database.dart';

import 'MechanicPage.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../global/global.dart';
import 'CustomerPage.dart';
import 'RegisterScreen.dart';
import 'ForgotPassword.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailtext = TextEditingController();
  final passwordtext = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String rolep = 'Mechanic';
  bool _passwordvis = false;

  void _submit() async {
    print(emailtext.text.trim());
    print(passwordtext.text.trim());
    // vejailla jinish.. work na korle change koro
    if (_formKey.currentState!.validate()) {
      print("Inside if condition");

      await firebaseAuth
          .signInWithEmailAndPassword(
              email: emailtext.text.trim(), password: passwordtext.text.trim())
          .then((auth) async {
        currentUser = auth.user;

        await Fluttertoast.showToast(msg: "Successfully Logged In");

        final ref = await FirebaseDatabase.instance
            .ref()
            .child('users')
            .child(currentUser!.uid)
            .get();

        if (ref.exists) {
          var bal = ref.value as Map;
          rolep = bal['role'];
        } else {
          print('No data available.');
        }

        if (rolep == "User") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (c) =>
                      CustomerPage())); //replace with userprofile page
        } else if (rolep == "Mechanic") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (c) =>
                      MechanicPage())); //replace with mechanicprofile page
        }
      }).catchError((err) {
        Fluttertoast.showToast(msg: "Log In Failed");
      });
    } else {
      Fluttertoast.showToast(msg: "Something went wrong!!");
    }
  }

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
                  // Image.asset(
                  //     darkTheme ? "images/banner.png" : "images/spanner.png"),
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    "Log In",
                    style: TextStyle(
                        color: darkTheme ? Colors.amber.shade300 : Colors.blue,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 50, 15, 180),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(50)
                                  ],
                                  decoration: InputDecoration(
                                      hintText: "email",
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                      ),
                                      filled: true,
                                      fillColor: darkTheme
                                          ? Colors.black45
                                          : Colors.grey.shade200,
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                          borderSide: BorderSide(
                                              width: 0,
                                              style: BorderStyle.none)),
                                      prefixIcon: Icon(
                                        Icons.mail,
                                        color: darkTheme
                                            ? Colors.amber.shade400
                                            : Colors.grey,
                                      )),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (text) {
                                    if (text == null || text.isEmpty) {
                                      return "mail cant be empty";
                                    }
                                    if (EmailValidator.validate(text) == true) {
                                      return null;
                                    }
                                    if (text.length < 2) {
                                      return "mail is too short";
                                    }

                                    if (text.length > 49) {
                                      return "mail is too long";
                                    }
                                  },
                                  onChanged: (text) => setState(() {
                                    emailtext.text = text;
                                  }),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  obscureText: !_passwordvis,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(50)
                                  ],
                                  decoration: InputDecoration(
                                      hintText: "password",
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                      ),
                                      filled: true,
                                      fillColor: darkTheme
                                          ? Colors.black45
                                          : Colors.grey.shade200,
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                          borderSide: BorderSide(
                                              width: 0,
                                              style: BorderStyle.none)),
                                      prefixIcon: Icon(
                                        Icons.person,
                                        color: darkTheme
                                            ? Colors.amber.shade400
                                            : Colors.grey,
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _passwordvis
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: darkTheme
                                              ? Colors.amber.shade400
                                              : Colors.grey,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _passwordvis = !_passwordvis;
                                          });
                                        },
                                      )),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (text) {
                                    if (text == null || text.isEmpty) {
                                      return "password cant be empty";
                                    }
                                    if (text.length < 8) {
                                      return "password is too short";
                                    }

                                    if (text.length > 49) {
                                      return "password is too long";
                                    }
                                    return null;
                                  },
                                  onChanged: (text) => setState(() {
                                    passwordtext.text = text;
                                  }),
                                ),
                                SizedBox(
                                  height: 50,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: darkTheme
                                        ? Colors.amber.shade400
                                        : Colors.blue,
                                    onPrimary:
                                        darkTheme ? Colors.black : Colors.white,
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    minimumSize: Size(double.infinity, 45),
                                  ),
                                  onPressed: () {
                                    _submit();
                                  },
                                  child: Text(
                                    "Log In",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (c) => ForgotPassword()));
                                  },
                                  child: Text(
                                    "Forgot Password",
                                    style: TextStyle(
                                      color: darkTheme
                                          ? Colors.amber.shade400
                                          : Colors.blue,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Doesn't have an account?  ",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (c) =>
                                                    RegisterScreen()));
                                      },
                                      child: Text(
                                        "Register",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: darkTheme
                                              ? Colors.amber.shade400
                                              : Colors.blue,
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ))
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ));
  }
}
