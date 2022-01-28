import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:secure_real_time_chat_app/services/database.dart';
import 'package:secure_real_time_chat_app/widgets/widget.dart';

class SearchRoom extends StatefulWidget {

  @override
  _SearchRoomState createState() => _SearchRoomState();
}

class _SearchRoomState extends State<SearchRoom> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchTextEditingEditor = new TextEditingController();

  QuerySnapshot? searchSnapshot;

  initiateSearch () {
    databaseMethods.getUserByUsername(searchTextEditingEditor.text)
        .then((val){
          setState(() {
            searchSnapshot = val;
          });
    });
  }

  ///Create Chatroom, send user to new screen, use pushreplacement
  createChatroomAndStartConversation (String username) {
    List<String> users = [username, initiatorName];
    databaseMethods.createChatRoom(chatroomID, chatroomMap)
  }

  Widget searchList () {
    return searchSnapshot != null ? ListView.builder(
        itemCount: searchSnapshot?.docs.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
        return SearchTile(
          userName: searchSnapshot?.docs[index]["name"],
          userEmail: searchSnapshot?.docs[index]["email"],
        );
    }) : Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1.5, color: Colors.white54)
                ),
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
                          hintStyle: TextStyle(
                            color: Colors.white54
                          )
                        ),
                      )
                  ),
                  GestureDetector(
                    onTap: () {
                      initiateSearch();
                    },
                    child: Container(
                        child: const Icon(Icons.search, color: Colors.white54,),
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

class SearchTile extends StatelessWidget {

  final String userName;
  final String userEmail;
  SearchTile({required this.userName, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userName, style: biggerTextStyle(),),
              Text(userEmail, style: biggerTextStyle(),),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {

            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20)
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text("Message", style: biggerTextStyle(),),
            ),
          )
        ],
      ),
    );
  }
}
