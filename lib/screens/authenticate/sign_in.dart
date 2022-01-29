import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:secure_real_time_chat_app/helper/helper.dart';
import 'package:secure_real_time_chat_app/screens/chat_app/chatRoom.dart';
import 'package:secure_real_time_chat_app/services/auth.dart';
import 'package:secure_real_time_chat_app/services/database.dart';
import 'package:secure_real_time_chat_app/widgets/widget.dart';

class SignIn extends StatefulWidget {

  final Function toggle;
  SignIn(this.toggle);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final formKey = GlobalKey<FormState>();
  AuthService authService = new AuthService ();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  TextEditingController emailEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();

  bool isLoading = false;

  signInUser () {
    if (formKey.currentState!.validate()) {

      setState(() {
        isLoading = true;
      });

      authService.signInWithEmailAndPassword(emailEditingController.text,
          passwordEditingController.text).then((val) async {
            if (val != null ) {
              QuerySnapshot querySnapshot = await databaseMethods
                  .getUserByUserEmail(emailEditingController.text);

              print(querySnapshot.docs[0].get("email") + ", " +querySnapshot.docs[0].get("name"));
              HelperFunctions.saveUserEmailPreferences(querySnapshot.docs[0].get("email"));
              HelperFunctions.saveUsernamePreferences(querySnapshot.docs[0].get("name"));
              HelperFunctions.saveUserLogggedInPreferences(true);
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => ChatRoom()

              ));
            }else {
              setState(() {
                isLoading = false;
              });
            }
      });
    }
  }

  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: isLoading ? Container(
        child: Center(child: CircularProgressIndicator()),
      ): SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 100,
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailEditingController,
                        decoration: textFieldInputDecoration("email"),
                        style: simpleTextStyle(),
                          validator: (val) {
                            return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val!) ?
                              null : "Please provide a valid email";
                        }
                      ),
                      TextFormField(
                        obscureText: true,
                        controller: passwordEditingController,
                        decoration: textFieldInputDecoration("password"),
                        style: simpleTextStyle(),
                        validator: (val) {
                          return val!.length > 6 ? null : "Password is too short. Need more than 6 character";
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                GestureDetector(
                  onTap: () {
                    signInUser();
                  },
                  child: Container(
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
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account? ", style: simpleTextStyle(),),
                    GestureDetector(
                      onTap: () {
                        widget.toggle();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: const Text("Register now", style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          decoration: TextDecoration.underline,
                        ),),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 0,),
              ]
            ),
          ),
        ),
      ),
    );
  }
}
