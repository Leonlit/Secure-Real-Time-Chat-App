import 'package:flutter/material.dart';
import 'package:secure_real_time_chat_app/helper/theme.dart';

PreferredSizeWidget appBar (BuildContext context) {
    return AppBar(
        backgroundColor: THEME_COLOR,
        elevation: 0.0,
        title: const Text("Se-Chat"),
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