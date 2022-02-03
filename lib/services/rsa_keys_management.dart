import 'dart:io';
import 'package:pointycastle/export.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'package:secure_real_time_chat_app/helper/helper.dart';
import 'package:secure_real_time_chat_app/services/database.dart';
import 'package:pointycastle/src/platform_check/platform_check.dart';
import 'package:secure_real_time_chat_app/services/file_management.dart';

class RSAKeyManagement {

  String pubKey = "";

  RSAKeyManagement () {
    final pair = generateRSAkeyPair(exampleSecureRandom());
    final helper = RsaKeyHelper();
    this.pubKey = helper.encodePublicKeyToPemPKCS1(pair.publicKey);
    final privKey = pair.privateKey;
    savePrivKey(privKey);
  }

  String getPubKey () {
    return this.pubKey;
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

  savePrivKey(RSAPrivateKey privKey) async {
    final helper = RsaKeyHelper();
    StorePrivKeyToFile(helper.encodePrivateKeyToPemPKCS1(privKey));
  }

  StorePrivKeyToFile (String privKey) async {
    print("privKey: " + privKey);
    FileManagement fileManagement = new FileManagement();
    String uid = await HelperFunctions.getUserUIDPreferences();
    File file = await fileManagement.localFile("privKey_$uid.pem");
    file.writeAsString(privKey);
    final contents = await file.readAsString();
    print("reading file: ");
    print(contents);
  }
}