import "package:flutter/material.dart";
import 'package:secure_real_time_chat_app/services/auth.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  static const Color THEME_COLOR = Color.fromRGBO(124, 32, 191, 1.0);
  static const Color BACKGROUND_COLOR = Color.fromRGBO(40, 39, 39, 1.0);

  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BACKGROUND_COLOR,
      appBar: AppBar(
        backgroundColor: THEME_COLOR,
        elevation: 0.0,
        title: const Text("Sign in to se-chat"),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Column(
          children: [
            const TextField(
              decoration: InputDecoration(
                hintText: "email",
                hintStyle: TextStyle(
                  color: Colors.white54
                )
              ),
            ),
            const TextField(
              decoration: InputDecoration(
                  hintText: "password"
              ),
            ),
            ElevatedButton(
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
          ]
        ),
      ),
    );
  }
}
