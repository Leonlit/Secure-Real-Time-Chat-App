import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class DatabaseMethods {
  getUserByUsername(String username) async {
    return await FirebaseFirestore.instance.collection("users")
        .where("name", isEqualTo: username)
        .get();
  }

  Future<String> getUserIdByEmail (String email) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("users")
        .where("email", isEqualTo: email)
        .get();
    return snapshot.docs.first.id;
  }

  getUserByUserEmail(String email) async {
    return await FirebaseFirestore.instance.collection("users")
        .where("email", isEqualTo: email)
        .get();
  }

  getConversationMessages(String chatRoomId){
    return FirebaseFirestore.instance.collection("chatroom")
        .doc(chatRoomId)
        .collection("chat")
        .orderBy('time')
        .snapshots();
  }

  getChatRoom (String userName) {
    return FirebaseFirestore.instance.collection("chatroom")
        .where("users", arrayContains: userName)
        .snapshots();
  }

  Future<DocumentSnapshot> getChatRoomByID (String chatRoomId) {
    return FirebaseFirestore.instance.collection("chatroom")
        .doc(chatRoomId)
        .get();
  }

  Future<bool> isChatRoomExists(String chatRoomId) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection("chatroom")
        .doc(chatRoomId)
        .get();
    return snapshot.exists;
  }

  addConversationMessages(String chatRoomId, messageMap) {
    FirebaseFirestore.instance.collection("chatroom")
        .doc(chatRoomId)
        .collection("chat")
        .add(messageMap).catchError((e) => {print(e)});
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