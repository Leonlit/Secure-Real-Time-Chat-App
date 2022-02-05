import 'package:flutter/material.dart';
import 'package:secure_real_time_chat_app/helper/authenticate.dart';
import 'package:secure_real_time_chat_app/helper/helper.dart';
import 'package:secure_real_time_chat_app/helper/test.dart';
import 'package:secure_real_time_chat_app/helper/theme.dart';
import 'package:secure_real_time_chat_app/screens/chat_app/chatRoom.dart';
import 'package:secure_real_time_chat_app/screens/users/profile.dart';
import 'package:secure_real_time_chat_app/services/auth.dart';
import 'package:secure_real_time_chat_app/services/database.dart';
import 'package:secure_real_time_chat_app/services/fileUploader.dart';

PreferredSizeWidget appBar (BuildContext context) {
    return AppBar(
        backgroundColor: THEME_COLOR,
        elevation: 0.0,
        title: const Text("Se-Chat"),
    );
}

Widget drawer (context) {
    return Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
                DrawerHeader(
                    decoration: const BoxDecoration(
                        color: THEME_COLOR,
                    ),
                    child: Text('Se-Chat', style: headerTextStyle(),),
                ),
                ListTile(
                    title: Text('Home', style: headerTextStyle(),),
                    onTap: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (context) => ChatRoom()
                        ));
                    },
                ),
                ListTile(
                    title: Text('Profile', style: headerTextStyle(),),
                    onTap: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (context) => ProfilePage()
                        ));
                    },
                ),
                ListTile(
                    title: Text('Sign Out', style: headerTextStyle()),
                    onTap: () {
                        AuthService authService = new AuthService ();
                        authService.signOut();
                        HelperFunctions.saveUserLogggedInPreferences(false);
                        Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (context) => Authenticate()
                        ));
                    },
                ),
            ],
        ),
    );
}

InputDecoration textFieldInputDecoration(String hint) {
    return InputDecoration(
        border: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white)
        ),
        enabledBorder: const UnderlineInputBorder(
            borderSide:  BorderSide(color: Colors.white)
        ),
        hintText: hint,
        hintStyle: const TextStyle(
            color: Colors.white54
        ),
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white)
        )
    );
}

TextStyle simpleTextStyle () {
    return const TextStyle(color: Colors.white, fontSize: 16);
}

TextStyle biggerTextStyle () {
    return const TextStyle(color: Colors.white, fontSize: 20);
}

TextStyle headerTextStyle () {
    return const TextStyle(fontSize: 22);
}