import 'package:cloud_firestore/cloud_firestore.dart';

class MechanicModel {
  String? id;
  bool? ionline;
  double latitude;
  double longitude;
  String name;
  String phone;
  double? rating;

  MechanicModel({
    this.id,
    this.ionline,
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.phone,
    this.rating,
  });

  static Future<MechanicModel> fetchMechanicData(String id) async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').doc(id).get();

    if (snapshot.exists) {
      Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
      // Create a new MechanicModel object with the fetched data
      return MechanicModel(
        id: userData['id'],
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
