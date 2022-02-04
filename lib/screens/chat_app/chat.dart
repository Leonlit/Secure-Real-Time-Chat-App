import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:secure_real_time_chat_app/helper/constants.dart';
import 'package:secure_real_time_chat_app/helper/helper.dart';
import 'package:secure_real_time_chat_app/helper/theme.dart';
import 'package:secure_real_time_chat_app/services/database.dart';
import 'package:secure_real_time_chat_app/services/encryption_management.dart';
import 'package:secure_real_time_chat_app/widgets/widget.dart';

class Chat extends StatefulWidget {
  String chatRoomId;
  String thePersonChattingTo;

  Chat(this.chatRoomId, this.thePersonChattingTo);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  dynamic aesKey = "";
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageEditingEditor = new TextEditingController();


  Stream<QuerySnapshot>? chatMessageStream;

  Widget chatMessageList() {
    ScrollController listScrollController = ScrollController();
    Widget returnedWidget = StreamBuilder(
      stream: chatMessageStream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        StatelessWidget view = snapshot.hasData
            ? ListView(
                controller: listScrollController,
                shrinkWrap: false,
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  String message = Encryption_Management.decryptWithAESKey(
                      this.aesKey, document.get("message"));
                  print(message);
                  return MessageTile(
                    message: message,
                    sendByMe: Constants.myName == document.get("by"),
                  );
                }).toList(),
              )
            : Container();
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          if(listScrollController.hasClients){
            final position = listScrollController.position.maxScrollExtent;
            listScrollController.jumpTo(position);
          }
        });

        return view;
      },
    );

    return returnedWidget;
  }

  sendMessage() async {
    if (messageEditingEditor.text.isNotEmpty) {
      print(this.aesKey);
      String message = Encryption_Management.encryptWithAESKey(
          this.aesKey, messageEditingEditor.text);
      Map<String, dynamic> messageMap = {
        "message": message,
        "by": Constants.myName,
        'time': DateTime.now().millisecondsSinceEpoch,
      };
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);

      setState(() {
        messageEditingEditor.text = "";
      });
    }
  }

  getChatHistory() async {
    this.aesKey =
        await HelperFunctions.getAESKeysForChatRoom(widget.chatRoomId);
    if (aesKey == "" || aesKey == null) {
      print("get chatroom aes key from database");
      this.aesKey =
          await Encryption_Management.getAESKeyFromDatabase(widget.chatRoomId);
    }

    Stream<QuerySnapshot>? msgHistory =
        await databaseMethods.getConversationMessages(widget.chatRoomId);
    print(msgHistory?.length);
    if (msgHistory != null) {
      msgHistory.first.then((value) {
        print("Test when getting chat history");
        print(value.docs.first.id);
      });
      setState(() {
        chatMessageStream = msgHistory;
      });
    } else {
      print("empty history");
    }
  }

  @override
  void initState() {
    getChatHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: THEME_COLOR,
        elevation: 0.0,
        title: Text(widget.thePersonChattingTo),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 5.0),
        child: Stack(
          children: [
            Container (
                alignment: Alignment.topCenter,
                height: MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom - 150,
                child: chatMessageList()
            ),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: const BoxDecoration(
                  //color: BACKGROUND_COLOR,
                  border:
                      Border(top: BorderSide(width: 1, color: Colors.white54)),
                ),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      style: simpleTextStyle(),
                      controller: messageEditingEditor,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.white54)),
                    )),
                    GestureDetector(
                      onTap: () {
                        sendMessage();
                      },
                      child: Container(
                        child: const Icon(
                          Icons.send,
                          color: Colors.white54,
                        ),
                        padding: EdgeInsets.all(1),
                        height: 40,
                        width: 40,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;

  MessageTile({required this.message, required this.sendByMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8, bottom: 8, left: sendByMe ? 0 : 24, right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin:
            sendByMe ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: sendByMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomLeft: Radius.circular(23))
                : BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomRight: Radius.circular(23)),
            gradient: LinearGradient(
              colors: sendByMe
                  ? [const Color(0xFF7C20BF), const Color(0x7C6E20FF)]
                  : [const Color(0x1AFFFFFF), const Color(0x1AFFFFFF)],
            )),
        child: Text(message,
            textAlign: TextAlign.start,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: 'OverpassRegular',
                fontWeight: FontWeight.w300)),
      ),
    );
  }
}
