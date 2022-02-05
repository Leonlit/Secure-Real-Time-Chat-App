import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:secure_real_time_chat_app/helper/constants.dart';
import 'package:secure_real_time_chat_app/helper/helper.dart';
import 'package:secure_real_time_chat_app/helper/theme.dart';
import 'package:secure_real_time_chat_app/services/database.dart';
import 'package:secure_real_time_chat_app/services/encryption_management.dart';
import 'package:secure_real_time_chat_app/services/fileUploader.dart';
import 'package:secure_real_time_chat_app/services/file_management.dart';
import 'package:secure_real_time_chat_app/widgets/widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

dynamic aesKey = "";

class Chat extends StatefulWidget {
  String chatRoomId;
  String thePersonChattingTo;

  Chat(this.chatRoomId, this.thePersonChattingTo);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageEditingEditor = new TextEditingController();

  Stream<QuerySnapshot>? chatMessageStream;

  Widget chatMessageList() {
    print(MediaQuery.of(context).size.height -
        (MediaQuery.of(context).viewInsets.bottom ?? 0) -
        150);
    ScrollController listScrollController = ScrollController();
    Widget returnedWidget = StreamBuilder(
      stream: chatMessageStream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        StatelessWidget view = snapshot.hasData
            ? ListView(
                controller: listScrollController,
                shrinkWrap: false,
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  print("test");
                  if (!document.get("file")) {
                    String message = Encryption_Management.decryptWithAESKey(
                        aesKey, document.get("message"));
                    print(message);
                    return MessageTile(
                      message: message,
                      sendByMe: Constants.myName == document.get("by"),
                      isFile: false,
                      fileReferences: document.get("references"),
                    );
                  } else {
                    String fileReferences = document.get("message");
                    return MessageTile(
                        message: fileReferences,
                        sendByMe: Constants.myName == document.get("by"),
                        isFile: true,
                        fileReferences: document.get("references"));
                  }
                }).toList(),
              )
            : Container();
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          if (listScrollController.hasClients) {
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
      String message = Encryption_Management.encryptWithAESKey(
          aesKey, messageEditingEditor.text);
      Map<String, dynamic> messageMap = {
        "message": message,
        "by": Constants.myName,
        "references": "",
        "file": false,
        'time': DateTime.now().millisecondsSinceEpoch,
      };
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);

      setState(() {
        messageEditingEditor.text = "";
      });
    }
  }

  getChatHistory() async {
    aesKey =
        await HelperFunctions.getAESKeysForChatRoom(widget.chatRoomId);
    print("Is aes key there");
    print(aesKey);
    if (aesKey == "" || aesKey == null) {
      print("get chatroom aes key from database");
      aesKey =
          await Encryption_Management.getAESKeyFromDatabase(widget.chatRoomId);
      await HelperFunctions.saveAESKeysForChatRoom(
          widget.chatRoomId, aesKey);
    }

    Stream<QuerySnapshot>? msgHistory =
        await databaseMethods.getConversationMessages(widget.chatRoomId);

    print("Test when getting chat history");

    setState(() {
      chatMessageStream = msgHistory;
    });
  }

  @override
  void initState() {
    getChatHistory();
    super.initState();
  }

  uploadFile() {
    FileUploader fileUploader = new FileUploader(widget.chatRoomId);
    fileUploader.uploadFile();
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
            Container(
                alignment: Alignment.topCenter,
                height: MediaQuery.of(context).size.height -
                    (MediaQuery.of(context).viewInsets.bottom) -
                    150,
                child: chatMessageList()),
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
                    GestureDetector(
                      onTap: () {
                        uploadFile();
                      },
                      child: Container(
                        child: const Icon(
                          Icons.file_upload,
                          color: Colors.white54,
                        ),
                        padding: EdgeInsets.all(1),
                        height: 40,
                        width: 40,
                      ),
                    ),
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

downloadFile(String firebaseFileReferences, String filename) async {
  print("Test download button");
  FileManagement fileManagement = new FileManagement();
  String absolutePath = await fileManagement.localPath();
  String dir = "images";
  fileManagement.createDirIfNotExists("$absolutePath/$dir");
  File downloadToFile = await fileManagement.localFile("$dir/$filename");

  await firebase_storage.FirebaseStorage.instance
      .ref(firebaseFileReferences)
      .writeToFile(downloadToFile);

  Uint8List decryptedData = Encryption_Management.decryptBytesWithAESKey(aesKey, await downloadToFile.readAsBytes());
  downloadToFile.writeAsBytes(decryptedData);
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;
  final bool isFile;
  final String fileReferences;

  MessageTile(
      {required this.message,
      required this.sendByMe,
      required this.isFile,
      required this.fileReferences});

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
        child: isFile
            ? Container(
                child: Row(
                  children: [
                    Flexible(
                      child: const Icon(
                        Icons.description_sharp,
                        color: Colors.white54,
                        size: 40,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5 + 20,
                      child: Text(message,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'OverpassRegular',
                              fontWeight: FontWeight.w300)),
                    ),
                    Flexible(
                      child: GestureDetector(
                        onTap: () {
                          downloadFile(this.fileReferences, this.message);
                        },
                        child: Container(
                          child: const Icon(
                            Icons.file_download,
                            color: Colors.white54,
                            size: 40,
                          ),
                          padding: EdgeInsets.all(1),
                          height: 40,
                          width: 40,
                        ),
                      ),
                    )
                  ],
                ),
              )
            : Text(message,
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
