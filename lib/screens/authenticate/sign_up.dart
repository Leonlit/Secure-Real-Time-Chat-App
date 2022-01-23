import "package:flutter/material.dart";
import 'package:secure_real_time_chat_app/services/auth.dart';
import 'package:secure_real_time_chat_app/widgets/widget.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final formKey = GlobalKey<FormState>();
  TextEditingController usernameEditingController = TextEditingController();
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: SingleChildScrollView(
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
                      ),
                        TextFormField(
                          decoration: textFieldInputDecoration("email"),
                          style: simpleTextStyle(),
                          controller: emailEditingController,
                        ),
                        TextFormField(
                          decoration: textFieldInputDecoration("password"),
                          style: simpleTextStyle(),
                          controller: passwordEditingController,
                        ),],
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {

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
                      const Text("Sign in now", style:
                        TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                ]
            ),
          ),
        ),
      ),
    );
  }
}
