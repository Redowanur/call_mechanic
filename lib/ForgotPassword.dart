import 'package:call_mechanic/LoginScreen.dart';
import 'package:call_mechanic/global/global.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailtext = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _submit() {
    firebaseAuth
        .sendPasswordResetEmail(email: emailtext.text.trim())
        .then((value) {
      Fluttertoast.showToast(msg: "Password Reset Link Sent");
    }).onError((error, StackTrace) {
      Fluttertoast.showToast(msg: "Try again later");
    });
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
                    "Password Recovery",
                    style: TextStyle(
                        color: darkTheme ? Colors.amber.shade300 : Colors.blue,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'UberMove'),
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
                                    "Send Link via Email",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
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
                                      "Already have an account?  ",
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
