
import 'package:pointycastle/asymmetric/api.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';

class Encryption_Management {
  encryptWithPubKey (String key, String data) {
    final helper = RsaKeyHelper();
    RSAPublicKey pubKey = helper.parsePublicKeyFromPem(key);
    String encryptedData = encrypt(data, pubKey);
    return encryptedData;
  }

  decryptWithPubKey (String key, String data) {
    final helper = RsaKeyHelper();
    RSAPublicKey pubKey = helper.parsePublicKeyFromPem(key);
    String encryptedData = encrypt(data, pubKey);
    return encryptedData;
  }
}