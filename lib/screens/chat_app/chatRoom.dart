import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:secure_real_time_chat_app/helper/authenticate.dart';
import 'package:secure_real_time_chat_app/helper/constants.dart';
import 'package:secure_real_time_chat_app/helper/helper.dart';
import 'package:secure_real_time_chat_app/helper/theme.dart';
import 'package:secure_real_time_chat_app/screens/chat_app/searchUser.dart';
import 'package:secure_real_time_chat_app/services/auth.dart';
import 'package:secure_real_time_chat_app/services/database.dart';
import 'package:secure_real_time_chat_app/services/encryption_management.dart';
import 'package:secure_real_time_chat_app/widgets/widget.dart';

import 'chat.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({Key? key}) : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {

  AuthService authService = new AuthService ();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  Stream<QuerySnapshot>? chatRoomStream;

  Widget chatRoomList () {
    return StreamBuilder(
      stream: chatRoomStream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        return snapshot.hasData ? ListView(
          shrinkWrap: true,
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            return ChatRoomsTile(
              username: document.get("room_name")
                  .toString()
                  .replaceAll(Constants.myName, "")
                  .replaceAll("_", ""),
              chatRoomId: document.id
              ,);
          }).toList(),
        ): Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async{
    Constants.myName = await HelperFunctions.getUsernamePreferences();
    Constants.myEmail = await HelperFunctions.getUserEmailPreferences();
    print(await HelperFunctions.getUserUIDPreferences());
    bool privKeyExists = await Encryption_Management.isPrivKeyIfExists(await HelperFunctions.getUserUIDPreferences());
    print(privKeyExists);
    if (!privKeyExists) {
      Encryption_Management.recreateRSAKeys(await HelperFunctions.getUserUIDPreferences(), context);
      await databaseMethods.deleteAllChatFromUser(Constants.myName);
      Alert(
        context: context,
        type: AlertType.warning,
        title: "Deleting all old chatRoom",
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
    }

    Stream<QuerySnapshot>? chatRooms = await databaseMethods.getChatRoom(Constants.myName);
    if (chatRooms != null) {
      setState(() {
        chatRoomStream = chatRooms;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer(context) ,
      appBar: appBar(context),
      floatingActionButton: FloatingActionButton (
        backgroundColor: THEME_COLOR,
        child: const Icon(Icons.search),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => SearchRoom()
          ));
          },
      ),
      body: Container(
        child: chatRoomList(),
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String username;
  final String chatRoomId;

  ChatRoomsTile({required this.username,required this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => Chat(
                chatRoomId,
                username
            )
        ));
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.black26,
          border: Border(
              bottom: BorderSide(width: 1, color: Color(0xff404040))
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  color: THEME_COLOR,
                  borderRadius: BorderRadius.circular(30)
              ),
              child: Icon(Icons.person, color: Colors.white54,size: 30,)/*Text(username.substring(0, 1).toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontFamily: 'OverpassRegular',
                      fontWeight: FontWeight.w300)),
                      */
            ),
            const SizedBox(
              width: 20,
            ),
            Text(username,
                textAlign: TextAlign.start,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'OverpassRegular',
                    fontWeight: FontWeight.w300))
          ],
        ),
      ),
    );
  }
}