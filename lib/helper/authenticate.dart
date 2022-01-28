import "package:flutter/material.dart";
import 'package:secure_real_time_chat_app/screens/authenticate/sign_in.dart';
import 'package:secure_real_time_chat_app/screens/authenticate/sign_up.dart';
import 'package:secure_real_time_chat_app/screens/chat_app/chatRoom.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  void toggleView () {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  bool showSignIn = true;

  @override
  Widget build(BuildContext context) {
    return showSignIn ? SignIn(toggleView) : SignUp(toggleView);
  }
}
