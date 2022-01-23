import "package:flutter/material.dart";
import 'package:secure_real_time_chat_app/services/auth.dart';
import 'package:secure_real_time_chat_app/widgets/widget.dart';


class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {


  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 100,
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: textFieldInputDecoration("email"),
                  style: simpleTextStyle(),
                ),
                TextField(
                  decoration: textFieldInputDecoration("password"),
                  style: simpleTextStyle(),
                ),
                SizedBox(height: 20,),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF7C20BF),
                        Color(0x7C6E20FF)
                      ]
                    ),
                    borderRadius: BorderRadius.circular(25)
                  ), 
                  child: Text("Sign In", style: biggerTextStyle()),
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account? ", style: simpleTextStyle(),),
                    const Text("Register now", style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      decoration: TextDecoration.underline,
                    ),),
                  ],
                ),
                SizedBox(height: 50,),
              ]
            ),
          ),
        ),
      ),
    );
  }
}
