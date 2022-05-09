import 'dart:convert';
import 'package:chat_app/models/message.dart';
import 'package:cryptography/cryptography.dart';

class CryptoController {
  static final algorithm = AesCbc.with128bits(macAlgorithm: MacAlgorithm.empty);

  Future<SecretBox> encrypt(String message, String key) async {
    final newKey = await algorithm.newSecretKeyFromBytes(utf8.encode(key));
    final secretBox =
        await algorithm.encrypt(utf8.encode(message), secretKey: newKey);
    return secretBox;
  }

  Future<String> decrypt(Message message, key) async {
    final newKey = await algorithm.newSecretKeyFromBytes(utf8.encode(key));
    final newSecretBox = SecretBox.fromConcatenation(message.secretBox,
        nonceLength: 16, macLength: 0);
    final clearText = await algorithm.decrypt(newSecretBox, secretKey: newKey);
    return utf8.decode(clearText);
  }
}
