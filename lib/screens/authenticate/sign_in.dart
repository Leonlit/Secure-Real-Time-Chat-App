import "package:flutter/material.dart";
import 'package:secure_real_time_chat_app/services/auth.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0.0,
        title: const Text("Sign in to app"),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: ElevatedButton(
          child: const Text("Sign In Anon"),
          onPressed: () async {
            dynamic login = await _auth.signInAnon();
            if (login == null) {
              print("Error signing in!");
            }else {
              print("signed in!");
              print(login);
            }
          },
        ),
      ),
    );
  }
}
