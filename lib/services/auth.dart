import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import "package:secure_real_time_chat_app/models/user.dart";


class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create new user object based on firebase user

  AppUser? _userFromFirebaseUser (User? user) {
    return user != null ? AppUser(user.uid): null;
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

  Future signInWithEmailAndPassword(String email, String password) async{
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return _userFromFirebaseUser(result.user);
    }catch (e) {
      print(e);
    }
  }

  // register

  Future signUpWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return _userFromFirebaseUser(result.user);
    }catch (e) {
      print(e);
    }
  }

  // sign out

  Future signOut () async {
    try {
      return await _auth.signOut();
    }catch (e) {
      print(e);
    }
  }
}