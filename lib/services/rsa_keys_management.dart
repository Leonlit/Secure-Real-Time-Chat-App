import 'dart:io';
import 'package:pointycastle/export.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'package:secure_real_time_chat_app/services/database.dart';
import 'package:pointycastle/src/platform_check/platform_check.dart';

import 'package:pointycastle/api.dart' as crypto;
import 'package:secure_real_time_chat_app/services/file_management.dart';

class RSAKeyManagement {

  RSAKeyManagement () {
    final pair = generateRSAkeyPair(exampleSecureRandom());
    final pubKey = pair.publicKey;
    final privKey = pair.privateKey;
    saveKeyPair(pubKey, privKey);
  }

  AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> generateRSAkeyPair(SecureRandom secureRandom, {int bitLength = 2048}) {
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
      ..seed(KeyParameter(
          Platform.instance.platformEntropySource().getBytes(32))
      );
    return secureRandom;
  }

  StorePrivKeyToFile (String privKey) async {
    print("privKey: " + privKey);
    FileManagement fileManagement = new FileManagement();
    File file = await fileManagement.localFile("privKey.pem");
    file.writeAsString(privKey);
    final contents = await file.readAsString();
    print("reading file: ");
    print(contents);
  }

  saveKeyPair(RSAPublicKey pubKey, RSAPrivateKey privKey) {
    DatabaseMethods databaseMethods = new DatabaseMethods();
    final helper = RsaKeyHelper();

    Map<String, dynamic> data = {
      "userID": "GOHCRMMQbc5a152FkMr1",
      "pubKey": helper.encodePublicKeyToPemPKCS1(pubKey),
    };

    print("privKey: " + helper.encodePublicKeyToPemPKCS1(pubKey));

    databaseMethods.saveUserPublicKey(data);
    StorePrivKeyToFile(helper.encodePrivateKeyToPemPKCS1(privKey));
  }
}