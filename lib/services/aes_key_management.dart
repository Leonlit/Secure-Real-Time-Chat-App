import 'dart:io';
import 'package:encrypt/encrypt.dart';
import 'dart:math';

import 'file_management.dart';

class AESKeyManagement {
  dynamic iv;
  String key = "";

  AESKeyManagement() {
    AES key = generateAESKey();
    IV iv = IV.fromSecureRandom(16);
    String keyBase64 = key.key.base64;
    String iv_base64 = iv.base64;
    print("IV is: ");
    print(iv_base64);
    print("key is is: ");
    print(keyBase64);
    this.key = "$keyBase64:$iv_base64";
  }

  generateAESKey() {
    final key = Key.fromSecureRandom(32);
    print(Key.fromSecureRandom(32));
    return AES(key);
  }

  getAESKey() {
    return this.key;
  }
}
