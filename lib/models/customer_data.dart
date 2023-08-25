import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerModel {
  bool? ionline;
  double latitude;
  double longitude;
  String name;
  String phone;
  double? rating;
  int? totalRequests;

  CustomerModel({
    this.ionline,
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.phone,
    this.rating,
    this.totalRequests,
  });

  static Future<CustomerModel> fetchCustomerData(String id) async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').doc(id).get();

    if (snapshot.exists) {
      Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
      // Create a new MechanicModel object with the fetched data
      return CustomerModel(
        ionline: userData['isOnline'],
        latitude: userData['latitude'],
        longitude: userData['longitude'],
        name: userData['name'],
        phone: userData['phone'],
        rating: userData['rating'],
        totalRequests: userData['totalRequests'],
      );
    } else {
      // If the document doesn't exist, throw an exception
      throw Exception('Customer data not found for ID: $id');
    }
  }
}
