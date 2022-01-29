import "package:flutter/material.dart";
import 'package:secure_real_time_chat_app/helper/authenticate.dart';
import 'package:secure_real_time_chat_app/helper/constants.dart';
import 'package:secure_real_time_chat_app/helper/helper.dart';
import 'package:secure_real_time_chat_app/helper/theme.dart';
import 'package:secure_real_time_chat_app/screens/chat_app/searchUser.dart';
import 'package:secure_real_time_chat_app/services/auth.dart';
import 'package:secure_real_time_chat_app/widgets/widget.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({Key? key}) : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {

  AuthService authService = new AuthService ();

  @override
  void initState() {
    getUserInfo();
    // TODO: implement initState
    super.initState();
  }

  getUserInfo() async{
    Constants.myName = await HelperFunctions.getUsernamePreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: THEME_COLOR,
        elevation: 0.0,
        title: const Text("Se-Chat"),
        actions: [
          GestureDetector(
            onTap: () {
              authService.signOut();
              HelperFunctions.saveUserLogggedInPreferences(false);
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => Authenticate()
              ));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Icon(Icons.exit_to_app),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton (
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => SearchRoom()
          ));
          },
      ),
    );
  }
}

