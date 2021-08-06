import 'package:flutter/material.dart';
import 'authentication/auth.dart';
import 'authentication/root_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FoodCourt',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: RootPage(
        auth: new Auth(),
        st: 'Register',
      ),
    );
  }
}
