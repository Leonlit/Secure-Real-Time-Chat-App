import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:pointycastle/asymmetric/api.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:secure_real_time_chat_app/helper/helper.dart';
import 'package:secure_real_time_chat_app/screens/chat_app/chatRoom.dart';
import 'package:secure_real_time_chat_app/services/auth.dart';
import 'package:secure_real_time_chat_app/services/database.dart';
import 'package:secure_real_time_chat_app/services/rsa_keys_management.dart';
import 'package:secure_real_time_chat_app/widgets/widget.dart';

class SignUp extends StatefulWidget {

  final Function toggle;
  SignUp(this.toggle);


  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {


  bool isLoading = false;
  AuthService authService = new AuthService ();

  final formKey = GlobalKey<FormState>();
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController usernameEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();

  DatabaseMethods databaseMethods = new DatabaseMethods();

  signUpUser (){
    if (formKey.currentState!.validate()) {

      HelperFunctions.saveUsernamePreferences(usernameEditingController.text);
      HelperFunctions.saveUserEmailPreferences(emailEditingController.text);

      setState(() {
        isLoading = true;
      });

      authService.signUpWithEmailAndPassword(
          emailEditingController.text,
          passwordEditingController.text).then((val) async{
            if (val != null) {
              RSAKeyManagement keymanagement = new RSAKeyManagement();

              Map<String, String> userInfoMap = {
                "name": usernameEditingController.text,
                "email": emailEditingController.text,
                "pubKey": keymanagement.pubKey
              };
              await databaseMethods.uploadUserInfo(userInfoMap);
              await keymanagement.savePrivKey();
              QuerySnapshot querySnapshot = await databaseMethods
                  .getUserByUserEmail(emailEditingController.text);

              HelperFunctions.saveUserEmailPreferences(querySnapshot.docs[0].get("email"));
              HelperFunctions.saveUsernamePreferences(querySnapshot.docs[0].get("name"));
              HelperFunctions.saveUserUIDPreferences(querySnapshot.docs[0].id);
              HelperFunctions.saveUserLogggedInPreferences(true);
              print("user UID: ");

              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => ChatRoom()
              ));
            }else {
              setState(() {
                isLoading = false;
                Alert(
                  context: context,
                  type: AlertType.error,
                  title: "Email already registered",
                  desc: "There is already an account that's associated with that email in our database. Please try Again!",
                  buttons: [
                    DialogButton(
                      child: Text(
                        "Ok",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onPressed: () => Navigator.pop(context),
                      width: 120,
                    )
                  ],
                ).show();
              });
            }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: isLoading ? Container(
        child: const Center(child: CircularProgressIndicator()),
      ) : SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 100,
          alignment: Alignment.center,
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
                        decoration: textFieldInputDecoration("username"),
                        style: simpleTextStyle(),
                        controller: usernameEditingController,
                          validator: (val) {
                            return val!.isEmpty ? "The username cannot be empty" : val!.length < 4 ? "The username is too short" : null;
                          },
                      ),
                        TextFormField(
                          decoration: textFieldInputDecoration("email"),
                          style: simpleTextStyle(),
                          controller: emailEditingController,
                          validator: (val){
                            return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val!) ?
                            null : "Please provide a valid email";
                          },
                        ),
                        TextFormField(
                          obscureText: true,
                          decoration: textFieldInputDecoration("password"),
                          style: simpleTextStyle(),
                          controller: passwordEditingController,
                          validator: (val) {
                            return val!.length > 6 ? null : "Password is too short. Need more than 6 character";
                          },
                        ),],
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      signUpUser();
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
                      child: Text("Sign Up", style: biggerTextStyle()),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account? ", style: simpleTextStyle(),),
                      GestureDetector(
                        onTap: () {
                          widget.toggle();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: const Text("Sign in now", style:
                            TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 0),
                ]
            ),
          ),
        ),
      ),
    );
  }
}
