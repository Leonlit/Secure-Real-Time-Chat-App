import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pointycastle/export.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'package:secure_real_time_chat_app/helper/helper.dart';
import 'package:secure_real_time_chat_app/services/database.dart';
import 'package:pointycastle/src/platform_check/platform_check.dart';
import 'package:secure_real_time_chat_app/services/file_management.dart';

class RSAKeyManagement {
  String pubKey = "";
  String privKey = "";

  RSAKeyManagement() {
    final pair = generateRSAkeyPair(exampleSecureRandom());
    final helper = RsaKeyHelper();
    this.pubKey = helper.encodePublicKeyToPemPKCS1(pair.publicKey);
    this.privKey = helper.encodePrivateKeyToPemPKCS1(pair.privateKey);
  }

  String getPubKey() {
    return this.pubKey;
  }

  AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> generateRSAkeyPair(
      SecureRandom secureRandom,
      {int bitLength = 2048}) {
    final keyGen = RSAKeyGenerator()
      ..init(ParametersWithRandom(
          RSAKeyGeneratorParameters(BigInt.parse('65537'), bitLength, 64),
          secureRandom));

    final pair = keyGen.generateKeyPair();
    final myPublic = pair.publicKey as RSAPublicKey;
    final myPrivate = pair.privateKey as RSAPrivateKey;

    return AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>(myPublic, myPrivate);
  }

  SecureRandom exampleSecureRandom() {
    final secureRandom = SecureRandom('Fortuna')
      ..seed(
          KeyParameter(Platform.instance.platformEntropySource().getBytes(32)));
    return secureRandom;
  }

  savePrivKey() async {
    StorePrivKeyToFile(this.privKey);
  }

  StorePrivKeyToFile(String privKey) async {
    DatabaseMethods databaseMethods = new DatabaseMethods();
    FileManagement fileManagement = new FileManagement();
    String uid = await databaseMethods.getUserIdByEmail(await HelperFunctions.getUserEmailPreferences());
    await HelperFunctions.saveUserUIDPreferences(uid);
    File file = await fileManagement.localFile("privKey_$uid.pem");
    file.writeAsString(privKey);
    final contents = await file.readAsString();
    print("reading file: ");
    print(contents);
  }
}
