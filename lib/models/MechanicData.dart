import 'package:cloud_firestore/cloud_firestore.dart';

class MechanicModel {
  bool? ionline;
  double? latitude;
  double? longitude;
  String? name;
  String? phone;
  double? rating;

  MechanicModel({
    this.ionline,
    this.latitude,
    this.longitude,
    this.name,
    this.phone,
    this.rating,
  });

  static Future<MechanicModel> fetchdata(String id) async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').doc(id).get();

    if (snapshot.exists) {
      Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
      // Create a new MechanicModel object with the fetched data
      return MechanicModel(
        ionline: userData['isOnline'],
        latitude: userData['latitude'],
        longitude: userData['longitude'],
        name: userData['name'],
        phone: userData['phone'],
        rating: userData['rating'],
      );
    } else {
      // If the document doesn't exist, throw an exception
      throw Exception('Mechanic data not found for ID: $id');
    }
  }
}
