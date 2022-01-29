import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  static String sharedPreferenceUserLoggedInKey = "IS_LOGGED_IN";
  static String sharedPreferenceUsernameKey = "USERNAME_KEY";
  static String sharedPreferenceUserEmailKey = "USER_EMAIL_KEY";

  //save preferences
  static Future<bool> saveUserLogggedInPreferences (bool userLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(sharedPreferenceUserLoggedInKey, userLoggedIn);
  }

  static Future<bool> saveUsernamePreferences (String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserLoggedInKey, username);
  }

  static Future<bool> saveUserEmailPreferences (String userEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserEmailKey, userEmail);
  }

  //getting preferences data
  static Future<bool?> getUserLoggedInPreferences () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getBool(sharedPreferenceUserEmailKey);
  }

  static Future<String?> getUsernamePreferences  () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(sharedPreferenceUserLoggedInKey);
  }

  static Future<String?> getUserEmailPreferences () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(sharedPreferenceUserEmailKey);
  }


}