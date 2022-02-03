import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  static String sharedPreferenceUserLoggedInKey = "IS_LOGGED_IN";
  static String sharedPreferenceUsernameKey = "USERNAME_KEY";
  static String sharedPreferenceUserEmailKey = "USER_EMAIL_KEY";
  static String sharedPreferenceUserUID = "USER_UID";
  static String sharedPreferenceAESKeys = "";

  //save preferences
  static Future<bool> saveUserLogggedInPreferences (bool userLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(sharedPreferenceUserLoggedInKey, userLoggedIn);
  }

  static Future<bool> saveUsernamePreferences (String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUsernameKey, username);
  }

  static Future<bool> saveUserEmailPreferences (String userEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserEmailKey, userEmail);
  }

  static Future<bool> saveUserUIDPreferences (String userUID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserUID, userUID);
  }

  static Future<bool> saveAESKeysForChatRoom (String chatRoomID, String key) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (sharedPreferenceAESKeys != "") {
      String jsonString = prefs.getString(sharedPreferenceAESKeys)!;
      List<dynamic> oldKeysList = jsonDecode(jsonString);
      oldKeysList.add({
        "chatRoomID": chatRoomID,
        "key": key
      });
      jsonString = jsonEncode(oldKeysList);
      return await prefs.setString(sharedPreferenceAESKeys, jsonString);
    }
    return false;
  }

  //getting preferences data
  static Future<bool> getUserLoggedInPreferences () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool value = prefs.getBool(sharedPreferenceUserLoggedInKey) ?? false;
    return value;
  }

  static Future<dynamic> getUsernamePreferences  () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(sharedPreferenceUsernameKey);
  }

  static Future<dynamic> getUserEmailPreferences () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(sharedPreferenceUserEmailKey);
  }

  static Future<dynamic> getUserUIDPreferences () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(sharedPreferenceUserUID);
  }

  static Future<dynamic> getAESKeysForChatRoom (String chatRoomID, String key) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (sharedPreferenceAESKeys != "") {
      String jsonString = prefs.getString(sharedPreferenceAESKeys)!;
      List<dynamic> oldKeysList = jsonDecode(jsonString);
      for (var map in oldKeysList) {
        if (map?.containsKey("chatRoomID") ?? false) {
          if (map!["chatRoomID"] == chatRoomID) {
            return map!["key"];
          }
        }
      }
    }
    return null;
  }


}