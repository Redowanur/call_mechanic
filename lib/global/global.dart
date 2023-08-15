import 'package:call_mechanic/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

User? currentUser;
userModel? userModelCurrentInfo;