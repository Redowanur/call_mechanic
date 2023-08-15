import 'package:firebase_database/firebase_database.dart';

class userModel {
  String? phone;
  String? name;
  String? id;
  String? email;
  String? address;

  userModel({
    this.name,
    this.id,
    this.phone,
    this.email,
    this.address,
  });

  userModel.fromSnapshot(DataSnapshot snap) {
    phone = (snap.value as dynamic)["phone"];
    id = snap.key;
    name = (snap.value as dynamic)["name"];
    email = (snap.value as dynamic)["email"];
    address = (snap.value as dynamic)["address"];

  }
}
