import 'dart:convert';
import 'dart:typed_data';

import 'package:chat_app/models/device.dart';
import 'package:chat_app/models/messageLocation.dart';

class Message {
  final String? id;
  final String senderId;
  final String receiverId;
  final int timestamp;
  final String cipherText;
  final String nonce;
  final String ipAddress;
  final Device device;
  final MessageLocation location;

  late String content;

  Message(this.id, this.senderId, this.receiverId, this.timestamp,
      this.cipherText, this.nonce, this.ipAddress, this.device, this.location);

  get secretBox {
    List<int> tempCipherText = json.decode(cipherText).cast<int>();
    List<int> tempNonce = json.decode(nonce).cast<int>();

    var n = tempCipherText.length;
    if (tempNonce.isNotEmpty) {
      n += tempNonce.length;
    }
    final result = Uint8List(n);
    var i = 0;
    if (tempNonce.isNotEmpty) {
      result.setAll(i, tempNonce);
      i += tempNonce.length;
    }
    result.setAll(i, tempCipherText);
    i += tempCipherText.length;
    return result;
  }
}
