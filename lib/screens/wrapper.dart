import "package:flutter/material.dart";
import 'package:secure_real_time_chat_app/screens/authenticate/authenticate.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //home or authenticate widget
    return Authenticate();
  }
}
