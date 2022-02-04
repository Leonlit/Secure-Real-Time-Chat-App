import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'package:secure_real_time_chat_app/helper/constants.dart';
import 'package:secure_real_time_chat_app/helper/helper.dart';
import 'package:secure_real_time_chat_app/services/database.dart';
import 'package:secure_real_time_chat_app/services/rsa_keys_management.dart';

import 'file_management.dart';

class Encryption_Management {
  static encryptWithRSAPubKey(String key, String data) {
    final helper = RsaKeyHelper();
    RSAPublicKey pubKey = helper.parsePublicKeyFromPem(key);
    String encryptedData = encrypt(data, pubKey);
    return encryptedData;
  }

  static decryptWithRSAPrivKey(String key, String data) {
    final helper = RsaKeyHelper();
    RSAPrivateKey privKey = helper.parsePrivateKeyFromPem(key);
    String decryptedData = decrypt(data, privKey);
    return decryptedData;
  }

  static getPrivKeyFromStorage(String uid) async{
    FileManagement fileManagement = new FileManagement();
    File file = await fileManagement.localFile("privKey_$uid.pem");
    return await file.readAsString();
  }

  static encryptWithAESKey (String key, String data) {
    dynamic keyArr = key.split(":");
    Key aesKey = Key.fromBase64(keyArr[0]);
    final encrypter = Encrypter(AES(aesKey));
    Encrypted encryptedData = encrypter.encrypt(data, iv: IV.fromBase64(keyArr[1]));
    return encryptedData.base64;
  }

  static decryptWithAESKey (String key, String data) {
    dynamic keyArr = key.split(":");
    Key aesKey = Key.fromBase64(keyArr[0]);
    final encrypter = Encrypter(AES(aesKey));
    Encrypted encrypted = Encrypted.fromBase64(data);
    String decryptedData = encrypter.decrypt(encrypted, iv: IV.fromBase64(keyArr[1]));
    return decryptedData;
  }

  static isPrivKeyIfExists (String uid) async{
    FileManagement fileManagement = new FileManagement();
    File file = await fileManagement.localFile("privKey_$uid.pem");
    return file.exists();
  }
  static recreateRSAKeys(String uid, context) {
    DatabaseMethods databaseMethods = new DatabaseMethods();
    Alert(context: context, title: "No private key file found!", desc: "Re-generating key pair as no private key for this user is found on this device ").show();
    print("Recreating priv key pem file\n\n");
    RSAKeyManagement keyManagement = new RSAKeyManagement();
    keyManagement.savePrivKey();
    databaseMethods.updateUserPublicKey(uid, keyManagement.getPubKey());
  }

  static getAESKeyFromDatabase (String chatroomID) async {
    DatabaseMethods databaseMethods = new DatabaseMethods();
    DocumentSnapshot snapshot = await databaseMethods.getChatRoomByID(chatroomID);
    String privKey = await Encryption_Management.getPrivKeyFromStorage(await HelperFunctions.getUserUIDPreferences());
    return await Encryption_Management.decryptWithRSAPrivKey(privKey, snapshot.get(Constants.myName));
  }
}
