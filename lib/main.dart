import 'package:call_mechanic/LoginScreen.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';

import 'themeprovider/theme_provider.dart';

Future<void> main() async {
  runApp(MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car Doctor',
      themeMode: ThemeMode.system,
      theme: MyThemes.lighttheme,
      darkTheme: MyThemes.darktheme,
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
