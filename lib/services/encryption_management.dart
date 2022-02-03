import 'dart:io';

import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';

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
    print("test");
    print(key);
    dynamic keyArr = key.split(":");
    Key aesKey = Key.fromBase64(keyArr[0]);
    final encrypter = Encrypter(AES(aesKey));
    Encrypted encryptedData = encrypter.encrypt(data, iv: IV.fromBase64(keyArr[1]));
    return encryptedData.base64;
  }

  static decryptWithAESKey (String key, String data) {
    print(key);
    dynamic keyArr = key.split(":");
    print(keyArr);
    Key aesKey = Key.fromBase64(keyArr[0]);
    final encrypter = Encrypter(AES(aesKey));
    Encrypted encrypted = Encrypted.fromBase64(data);
    String decryptedData = encrypter.decrypt(encrypted, iv: IV.fromBase64(keyArr[1]));
    return decryptedData;
  }
}
