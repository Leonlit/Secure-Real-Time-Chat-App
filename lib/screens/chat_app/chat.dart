import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:secure_real_time_chat_app/helper/constants.dart';
import 'package:secure_real_time_chat_app/services/database.dart';
import 'package:secure_real_time_chat_app/widgets/widget.dart';

class Conversation extends StatefulWidget {
  String chatRoomId;
  Conversation(this.chatRoomId);

  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {

  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageEditingEditor = new TextEditingController();

  late Stream<QuerySnapshot> chatMessageStream;

  /*Widget chatMessageList () {
    return StreamBuilder(
      stream: chatMessageStream,
      builder: (context, snapshot) {
        return snapshot.hasData? ListView.builder(
            itemCount: snapshot.data.,
            itemBuilder: (context, index) {
              return MessageTile(
                message: snapshot.data.documents[index].data["message"],
                sendByMe: Constants.myName == snapshot.data.documents[index].data["sendBy"],
              );
            },
        ): Container();
      },
    );
  }*/

  sendMessage () {
    if (messageEditingEditor.text.isNotEmpty) {
      Map<String, String> messageMap = {
        "message": messageEditingEditor.text,
        "by": Constants.myName
      };
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
    }
  }
  
  @override
  void initState() {
    databaseMethods.getConversationMessages(widget.chatRoomId).then((val) {
      setState(() {
        chatMessageStream = val;
      });
      print(chatMessageStream.single);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: Container(
        child: Stack(
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: const BoxDecoration(
                  border: Border(
                      top: BorderSide(width: 1, color: Colors.white54)
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                          style: simpleTextStyle(),
                          controller: messageEditingEditor,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                  color: Colors.white54
                              )
                          ),
                        )
                    ),
                    GestureDetector(
                      onTap: () {
                        sendMessage();
                      },
                      child: Container(
                        child: const Icon(Icons.send, color: Colors.white54,),
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
