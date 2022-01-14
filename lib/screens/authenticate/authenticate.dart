import 'package:flutter/material.dart';
import 'package:secure_real_time_chat_app/screens/authenticate/sign_in.dart';

class Authenticate extends StatefulWidget {

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  @override
  Widget build(BuildContext context) {
    return SignIn();
  }
}
