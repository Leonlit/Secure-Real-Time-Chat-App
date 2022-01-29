import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  getUserByUsername(String username) async {
    return await FirebaseFirestore.instance.collection("users")
        .where("name", isEqualTo: username)
        .get();
  }

  getUserByUserEmail(String email) async {
    return await FirebaseFirestore.instance.collection("users")
        .where("email", isEqualTo: email)
        .get();
  }

  uploadUserInfo (userMap) {
    FirebaseFirestore.instance.collection("users")
        .add(userMap);
  }

  createChatRoom (String chatroomID, chatroomMap) {
    FirebaseFirestore.instance.collection("chatroom")
        .doc(chatroomID).set(chatroomMap).catchError((e) {
          print(e);
    });
  }
}