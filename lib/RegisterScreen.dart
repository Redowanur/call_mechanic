// import 'package:call_mechanic/global/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import 'ForgotPassword.dart';
import 'LoginScreen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nametext = TextEditingController();
  final emailtext = TextEditingController();
  final phonetext = TextEditingController();
  final adresstext = TextEditingController();
  final passwordtext = TextEditingController();
  final confimtext = TextEditingController();
  String defrole = 'Select Role';
  bool isOnline = true;
  double latitude = 0, longitude = 0, rating = 0;

  bool _passwordvis = false;

  final _formKey = GlobalKey<FormState>();

  void _submit() async {
    print(defrole);
    if (_formKey.currentState!.validate() == false) {
      try {
        final authResult =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailtext.text.trim(),
          password: passwordtext.text.trim(),
        );
        final currentUser = authResult.user;

        final userRef = FirebaseFirestore.instance.collection('users');

        if (defrole == 'User') {
          await userRef.doc(currentUser!.uid).set({
            'id': currentUser.uid,
            'name': nametext.text.trim(),
            'email': emailtext.text.trim(),
            'address': adresstext.text.trim(),
            'phone': phonetext.text.trim(),
            'role': defrole,
            'latitude': latitude,
            'longitude': longitude,
          });
        } else if (defrole == 'Mechanic') {
          await userRef.doc(currentUser!.uid).set({
            'id': currentUser.uid,
            'name': nametext.text.trim(),
            'email': emailtext.text.trim(),
            'address': adresstext.text.trim(),
            'phone': phonetext.text.trim(),
            'role': defrole,
            'isOnline': isOnline,
            'latitude': latitude,
            'longitude': longitude,
            'rating': rating,
          });
        }

        await Fluttertoast.showToast(msg: "Successfully Registered");
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => LoginScreen()));
      } catch (error) {
        Fluttertoast.showToast(msg: "Registration Failed");
      }
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
                    height: 40,
                  ),
                  Text(
                    "Register",
                    style: TextStyle(
                        color: darkTheme ? Colors.amber.shade300 : Colors.blue,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'UberMove'),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 20, 15, 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextFormField(
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(50)
                                  ],
                                  decoration: InputDecoration(
                                      hintText: "name",
                                      hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontFamily: 'UberMove'),
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
                                      )),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (text) {
                                    if (text == null || text.isEmpty) {
                                      return "name cant be empty";
                                    }
                                    if (text.length < 2) {
                                      return "name is too short";
                                    }

                                    if (text.length > 49) {
                                      return "name is too long";
                                    }
                                  },
                                  onChanged: (text) => setState(() {
                                    nametext.text = text;
                                  }),
                                ),
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
                                          fontFamily: 'UberMove'),
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
                                IntlPhoneField(
                                  showCountryFlag: false,
                                  dropdownIcon: Icon(
                                    Icons.arrow_drop_down,
                                    color: darkTheme
                                        ? Colors.amber.shade400
                                        : Colors.grey,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "phone",
                                    hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontFamily: 'UberMove'),
                                    filled: true,
                                    fillColor: darkTheme
                                        ? Colors.black45
                                        : Colors.grey.shade200,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(40),
                                        borderSide: BorderSide(
                                            width: 0, style: BorderStyle.none)),
                                  ),
                                  initialCountryCode: 'BD',
                                  onChanged: (text) => setState(() {
                                    phonetext.text = text.completeNumber;
                                  }),
                                ),
                                TextFormField(
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(50)
                                  ],
                                  decoration: InputDecoration(
                                      hintText: "address",
                                      hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontFamily: 'UberMove'),
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
                                      )),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (text) {
                                    if (text == null || text.isEmpty) {
                                      return "adress cant be empty";
                                    }
                                    if (text.length < 2) {
                                      return "adress is too short";
                                    }

                                    if (text.length > 49) {
                                      return "adress is too long";
                                    }
                                  },
                                  onChanged: (text) => setState(() {
                                    adresstext.text = text;
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
                                          fontFamily: 'UberMove'),
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
                                  height: 20,
                                ),
                                TextFormField(
                                  obscureText: !_passwordvis,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(50)
                                  ],
                                  decoration: InputDecoration(
                                      hintText: "confirm password",
                                      hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontFamily: 'UberMove'),
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
                                      return "confirm password cant be empty";
                                    }
                                    if (text != passwordtext.text) {
                                      return "password dont match";
                                    }
                                    if (text == passwordtext.text) {
                                      return "password matched";
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
                                    confimtext.text = text;
                                  }),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                DropdownButtonFormField<String>(
                                  value: defrole,
                                  onChanged: (newValue) {
                                    setState(() {
                                      defrole = newValue!;
                                    });
                                  },
                                  items: <String>[
                                    'Select Role',
                                    'Mechanic',
                                    'User'
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.person,
                                            color: darkTheme
                                                ? Colors.amber.shade400
                                                : Colors.grey,
                                          ),
                                          SizedBox(width: 10),
                                          Text(value),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  decoration: InputDecoration(
                                    hintText: "Select Role",
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                    ),
                                    filled: true,
                                    fillColor: darkTheme
                                        ? Colors.black45
                                        : Colors.grey.shade200,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(40),
                                      borderSide: BorderSide(
                                        width: 0,
                                        style: BorderStyle.none,
                                      ),
                                    ),
                                  ),
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
                                    "Register",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'UberMove'),
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
                                        fontSize: 14,
                                        color: darkTheme
                                            ? Colors.amber.shade400
                                            : Colors.blue,
                                        fontFamily: 'UberMove'),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Have an account?  ",
                                      style: TextStyle(
                                          color: darkTheme
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 14,
                                          fontFamily: 'UberMove'),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (c) => LoginScreen()));
                                      },
                                      child: Text(
                                        "Sign In",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: darkTheme
                                                ? Colors.amber.shade400
                                                : Colors.blue,
                                            fontFamily: 'UberMove'),
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
