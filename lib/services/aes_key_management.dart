import 'dart:io';
import 'package:encrypt/encrypt.dart';
import 'dart:math';
import 'package:pointycastle/export.dart';
import 'package:pointycastle/api.dart' as crypto;
import 'package:pointycastle/src/platform_check/platform_check.dart';
import 'package:secure_real_time_chat_app/helper/helper.dart';

import 'file_management.dart';

class AESKeyManagement {
  dynamic iv;
  dynamic oppositeName;
  dynamic keyBase64;

  AESKeyManagement (String chatRoomID,String oppositeName) {
    AES key = generateAESKey();
    final iv = IV.fromLength(16);
    String keyBase64 = key.key.base64;
    saveAESKeyToFile(keyBase64, iv, oppositeName);
  }

  saveAESKeyToFile (key, iv, oppositeName) async{
    String myName = await HelperFunctions.getUsernamePreferences();
    FileManagement fileManagement = new FileManagement();
    File file = await fileManagement.localFile("$myName\_$oppositeName");
    String data = "$key:$iv";
    print(data);
    file.writeAsString(data);
    final contents = await file.readAsString();
    print(contents);
  }


  generateAESKey () {
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();
    String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
    final key = Key.fromUtf8(getRandomString(32));
    return AES(key);
  }
}