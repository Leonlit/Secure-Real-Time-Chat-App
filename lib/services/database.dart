import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class DatabaseMethods {
  getUserByUsername(String username) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: username)
        .get();
  }

  Future<String> getUserIdByEmail(String email) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get();
    return snapshot.docs.first.id;
  }

  getUserByUserEmail(String email) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get();
  }

  getConversationMessages(String chatRoomId) {
    return FirebaseFirestore.instance
        .collection("chatroom")
        .doc(chatRoomId)
        .collection("chat")
        .orderBy('time')
        .snapshots();
  }

  getChatRoom(String userName) {
    return FirebaseFirestore.instance
        .collection("chatroom")
        .where("users", arrayContains: userName)
        .snapshots();
  }

  Future<DocumentSnapshot> getChatRoomByID(String chatRoomId) {
    return FirebaseFirestore.instance
        .collection("chatroom")
        .doc(chatRoomId)
        .get();
  }

  Future<bool> isChatRoomExists(String chatRoomId) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatroom")
        .doc(chatRoomId)
        .get();
    return snapshot.exists;
  }

  addConversationMessages(String chatRoomId, messageMap) {
    FirebaseFirestore.instance
        .collection("chatroom")
        .doc(chatRoomId)
        .collection("chat")
        .add(messageMap)
        .catchError((e) => {print(e)});
  }

  uploadUserInfo(userMap) {
    FirebaseFirestore.instance.collection("users").add(userMap);
  }

  createChatRoom(String chatroomID, chatroomMap) {
    FirebaseFirestore.instance
        .collection("chatroom")
        .doc(chatroomID)
        .set(chatroomMap)
        .catchError((e) {
      print(e);
    });
  }

  storeFilesToFirebase (String chatRoomID, fileMap) {
    FirebaseFirestore.instance
        .collection("chatroom")
        .doc(chatRoomID)
        .collection("chat")
        .add(fileMap)
        .catchError((e) {
      print(e);
    });
  }

  updateUserPublicKey(String uid, String pubKey) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .update({"pubKey": pubKey}).catchError((e) {
      print(e);
    });
  }

  deleteAllChatFromUser(String username) {
    print("test username in database");
    print(username);
    FirebaseFirestore.instance.collection("chatroom")
        .where("users", arrayContains: username )
        .get()
        .then((snapshot) async {
        for (var doc in snapshot.docs) {
          print(doc.id);
          FirebaseFirestore.instance.collection("chatroom")
          .doc(doc.id)
          .collection("chat")
          .get()
          .then((value){
            for (var subDoc in value.docs) {
              subDoc.reference.delete();
            }
          });
          await doc.reference.delete();
        }
    });
  }
}
