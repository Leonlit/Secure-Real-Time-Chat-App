import 'package:flutter/material.dart';
import 'package:secure_real_time_chat_app/helper/constants.dart';
import 'package:secure_real_time_chat_app/helper/helper.dart';
import 'package:secure_real_time_chat_app/helper/theme.dart';
import 'package:secure_real_time_chat_app/widgets/widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: appBar(context),
      drawer: drawer(context),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            SizedBox(height: 20,),
            Align(
              alignment: Alignment.topRight,
              child: Text(
                Constants.myName ,
                style: biggerTextStyle(),
              ),
            ),
            SizedBox(height: 20,),
            Align(
              alignment: Alignment.topRight,
              child: Text(
                Constants.myEmail,
                style: biggerTextStyle(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}