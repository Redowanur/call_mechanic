import 'package:call_mechanic/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

User? currentUser;
userModel? userModelCurrentInfo;

List<String> slicingfunc(String input) {
  int hashLocation = input.indexOf('#');

  String beforeHash = input.substring(0, hashLocation);
  String afterHash = input.substring(hashLocation + 1);
  return [beforeHash, afterHash];
}
