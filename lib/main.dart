import 'package:flutter/material.dart';
import "package:firebase_core/firebase_core.dart";
import 'package:secure_real_time_chat_app/screens/wrapper.dart';
import 'package:secure_real_time_chat_app/helper/theme.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Se-Chat",
      home: Wrapper(),
      theme: ThemeData(
        primaryColor: BACKGROUND_COLOR,
        scaffoldBackgroundColor: BACKGROUND_COLOR,
        fontFamily: "OverpassRegular",
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}