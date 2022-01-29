import 'package:flutter/material.dart';
import "package:firebase_core/firebase_core.dart";
import 'package:secure_real_time_chat_app/helper/authenticate.dart';
import 'package:secure_real_time_chat_app/helper/helper.dart';
import 'package:secure_real_time_chat_app/helper/theme.dart';
import 'package:secure_real_time_chat_app/screens/chat_app/chatRoom.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool userIsLoggedIn = false;

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState ()async {
    await HelperFunctions.getUserLoggedInPreferences().then((value) => {
      setState(() {
        userIsLoggedIn =  value;
    })
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Se-Chat",
      home: userIsLoggedIn ? ChatRoom(): Authenticate(),
      theme: ThemeData(
        primaryColor: BACKGROUND_COLOR,
        scaffoldBackgroundColor: BACKGROUND_COLOR,
        fontFamily: "OverpassRegular",
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}

class Blank extends StatefulWidget {
  const Blank({Key? key}) : super(key: key);

  @override
  State<Blank> createState() => _BlankState();
}

class _BlankState extends State<Blank> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
