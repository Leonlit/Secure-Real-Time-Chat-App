import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import "package:secure_real_time_chat_app/models/user.dart";


class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create new user object based on firebaseuser

  AppUser? _userFromFirebaseUser (User? user) {
    try{
      if (user != null) {
        return AppUser(user.uid);
      }
    }catch (e) {
      print(e);
    }
    return null;
  }

  Stream<AppUser?> get user {
    return _auth.authStateChanges()
    .map(_userFromFirebaseUser);
  }

  //anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user!;
      return _userFromFirebaseUser(user);
    }catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign in email & password

  // register

  // sign out
}