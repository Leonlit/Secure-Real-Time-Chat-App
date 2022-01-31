import 'package:flutter/material.dart';
import 'package:pointycastle/src/platform_check/platform_check.dart';
import 'package:pointycastle/export.dart';
import 'package:secure_real_time_chat_app/services/database.dart';

AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> generateRSAkeyPair(
    SecureRandom secureRandom,
    {int bitLength = 2048}) {
  // Create an RSA key generator and initialize it

  final keyGen = RSAKeyGenerator()
    ..init(ParametersWithRandom(
        RSAKeyGeneratorParameters(BigInt.parse('65537'), bitLength, 64),
        secureRandom));

  // Use the generator

  final pair = keyGen.generateKeyPair();

  // Cast the generated key pair into the RSA key types

  final myPublic = pair.publicKey as RSAPublicKey;
  final myPrivate = pair.privateKey as RSAPrivateKey;

  return AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>(myPublic, myPrivate);
}

SecureRandom exampleSecureRandom() {
  final secureRandom = SecureRandom('Fortuna')
    ..seed(KeyParameter(
        Platform.instance.platformEntropySource().getBytes(32)));
  return secureRandom;
}

saveKeyPair (RSAPublicKey pubKey, RSAPrivateKey privKey) {
  DatabaseMethods databaseMethods = new DatabaseMethods();

  Map<String, dynamic> data = {
    "userID": "GOHCRMMQbc5a152FkMr1",
    "mod": pubKey.modulus,
    "exp": pubKey.exponent
  };

  databaseMethods.saveUserPublicKey(data);

}

/*
main() {
  final pair = generateRSAkeyPair(exampleSecureRandom());
  final pubKey = pair.publicKey;
  final privKey = pair.privateKey;
  saveKeyPair(pubKey, privKey);
}*/



