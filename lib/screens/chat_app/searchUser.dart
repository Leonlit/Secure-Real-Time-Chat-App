import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:secure_real_time_chat_app/helper/constants.dart';
import 'package:secure_real_time_chat_app/helper/helper.dart';
import 'package:secure_real_time_chat_app/services/aes_key_management.dart';
import 'package:secure_real_time_chat_app/services/database.dart';
import 'package:secure_real_time_chat_app/services/encryption_management.dart';
import 'package:secure_real_time_chat_app/services/file_management.dart';
import 'package:secure_real_time_chat_app/widgets/widget.dart';

import 'chat.dart';

class SearchRoom extends StatefulWidget {
  @override
  _SearchRoomState createState() => _SearchRoomState();
}

class _SearchRoomState extends State<SearchRoom> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchTextEditingEditor = new TextEditingController();

  QuerySnapshot? searchSnapshot;

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            itemCount: searchSnapshot?.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              if (searchSnapshot?.docs[index]["name"] == Constants.myName) {
                return Container();
              }
              return userTile(
                searchSnapshot?.docs[index]["name"],
                searchSnapshot?.docs[index]["email"],
              );
            })
        : Container();
  }

  initiateSearch() {
    databaseMethods.getUserByUsername(searchTextEditingEditor.text).then((val) {
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  getChatRoomID(String a, String b) {
    print(a + ", " + b);
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  rsaEncryptAESKey(String username, String aesKey) async {
    QuerySnapshot snapshot = await databaseMethods.getUserByUsername(username);
    String pubKey = snapshot.docs.single.get("pubKey");
    return Encryption_Management.encryptWithRSAPubKey(pubKey, aesKey);
  }

  sendMessage(String username) async {
    String myName = Constants.myName;
    if (myName != username) {
      String chatRoomID = getChatRoomID(Constants.myName, username);

      if (!(await databaseMethods.isChatRoomExists(chatRoomID))) {
        AESKeyManagement aesKeyManagement = new AESKeyManagement();
        String key = aesKeyManagement.getAESKey();

        String myEncryptedAES = await rsaEncryptAESKey(Constants.myName, key);
        String hisEncryptedAES = await rsaEncryptAESKey(username, key);
        await HelperFunctions.saveAESKeysForChatRoom(chatRoomID, key);

        List<String> users = [myName, username];
        Map<String, dynamic> chatRoomMap = {
          "users": users,
          "room_name": chatRoomID,
          "$myName": myEncryptedAES,
          "$username": hisEncryptedAES
        };
        databaseMethods.createChatRoom(chatRoomID, chatRoomMap);
      }
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => Chat(chatRoomID, username)));
    } else {
      print("Cannot chat with yourself");
    }
  }

  Widget userTile(String userName, String userEmail) {
    return Container(
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: biggerTextStyle(),
              ),
              Text(
                userEmail,
                style: biggerTextStyle(),
              ),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              sendMessage(userName);
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "Message",
                style: biggerTextStyle(),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 1.5, color: Colors.white54)),
              ),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    style: simpleTextStyle(),
                    controller: searchTextEditingEditor,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search Username...",
                        hintStyle: TextStyle(color: Colors.white54)),
                  )),
                  GestureDetector(
                    onTap: () {
                      initiateSearch();
                    },
                    child: Container(
                      child: const Icon(
                        Icons.search,
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
            const SizedBox(height: 20),
            searchList()
          ],
        ),
      ),
    );
  }
}
