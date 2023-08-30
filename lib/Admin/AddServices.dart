import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddServices extends StatefulWidget {
  const AddServices({super.key});

  @override
  State<AddServices> createState() => _AddServicesState();
}

class _AddServicesState extends State<AddServices> {
  final Servicetext = TextEditingController();
  final chargetext = TextEditingController();
  final urltext = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String rolep = '';
  String id = '';
  String name = '';
  String phone = '';
  double rating = 0.0;
  bool _passwordvis = false;
  bool isOnline = false;
  List<Map<String, dynamic>> requests = [];

  void _submit() async {
    String push = Servicetext.text.trim() +
        "#" +
        chargetext.text.trim() +
        '%' +
        urltext.text.trim();
    print(push);
    try {
      final userRef = FirebaseFirestore.instance.collection('services');
      await userRef.doc("ourservice").update({
        'service': FieldValue.arrayUnion([push]),
      });
      Fluttertoast.showToast(msg: "Service Added Successfully");
    } catch (e) {}
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
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    "Admin Panel",
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
                                      hintText: "Service Name",
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
                                        Icons.cleaning_services,
                                        color: darkTheme
                                            ? Colors.amber.shade400
                                            : Colors.grey,
                                      )),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (text) {
                                    if (text == null || text.isEmpty) {
                                      return "Service cant be empty";
                                    }
                                  },
                                  onChanged: (text) => setState(() {
                                    Servicetext.text = text;
                                  }),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  // obscureText: !_passwordvis,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(50)
                                  ],
                                  decoration: InputDecoration(
                                    hintText: "Service Charge (BDT)",
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
                                    prefixIcon: Icon(
                                      Icons.money,
                                      color: darkTheme
                                          ? Colors.amber.shade400
                                          : Colors.grey,
                                    ),
                                  ),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (text) {
                                    if (text?.indexOf('-') == 0 ||
                                        text == null) {
                                      return "Charge cannot be less than zero";
                                    }

                                    return null;
                                  },
                                  onChanged: (text) => setState(() {
                                    chargetext.text = text;
                                  }),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  // obscureText: !_passwordvis,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(1000)
                                  ],
                                  decoration: InputDecoration(
                                    hintText: "Service Image Url",
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
                                    prefixIcon: Icon(
                                      Icons.money,
                                      color: darkTheme
                                          ? Colors.amber.shade400
                                          : Colors.grey,
                                    ),
                                  ),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (text) {
                                    if (text!.isEmpty || text == null) {
                                      return "Url Invalid";
                                    }

                                    return null;
                                  },
                                  onChanged: (text) => setState(() {
                                    urltext.text = text;
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
                                    "Add Service",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'UberMove'),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
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
