import 'dart:convert';
import 'dart:developer';
import 'package:chat_app/models/messageLocation.dart';
import 'package:geolocator/geolocator.dart';

import 'package:chat_app/ui/controllers/location_controller.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';
import 'package:uuid/uuid.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';

import 'package:chat_app/models/message.dart';
import 'package:chat_app/models/device.dart';
import './crypto_controller.dart';

class ChatRoomController extends GetxController {
  var messages = <Message>[].obs;
  var uuid = const Uuid();
  final databaseRef = FirebaseDatabase.instance.ref('chats');
  final crypto = CryptoController();
  final networkInfo = NetworkInfo();
  final locationController = LocationController();
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  late Position position;

  initPos() async {
    position = await locationController.determinePosition();
  }

  var messageStream;

  fetchChatMessages(chatId, encryptKey) {
    messageStream = databaseRef
        .child('$chatId/messages')
        .orderByChild('timestamp')
        .onChildAdded
        .listen((DatabaseEvent event) async {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      log('data: $data');
      Device device = Device.fromJson(data["device"]);
      MessageLocation msgPos = MessageLocation.fromJson(data["position"]);

      var message = Message(
          event.snapshot.key,
          data['senderId'],
          data['receiverId'],
          data['timestamp'],
          data['cipherText'],
          data['nonce'],
          data['ipAddress'] == null ? '' : data['ipAddress'],
          device,
          msgPos);
      message.content = await crypto.decrypt(message, encryptKey);
      logInfo('Message content: ${message.content}.');
      messages.add(message);
    });
  }

  sendMessage(chatId, senderId, receiverId, content, encryptKey) async {
    log('chatId: $chatId');
    log('senderId: $senderId');
    log('receiverId: $receiverId');
    log('content: $content');
    log('encryptKey: $encryptKey');
    final messageId = uuid.v4();
    var wifiIP = await networkInfo.getWifiIP();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    logInfo(androidInfo.device);

    try {
      var messageTimestamp = DateTime.now().millisecondsSinceEpoch;
      var encryptedMessage = await crypto.encrypt(content, encryptKey);
      await FirebaseDatabase.instance
          .ref('chats/$chatId/messages/$messageId')
          .set({
        "senderId": senderId,
        "receiverId": receiverId,
        "nonce": encryptedMessage.nonce.toString(),
        "cipherText": encryptedMessage.cipherText.toString(),
        "timestamp": messageTimestamp,
        "ipAddress": wifiIP,
        "device": {
          "id": androidInfo.id,
          "model": androidInfo.model,
          "device": androidInfo.device
        },
        "position": {"lat": position.latitude, "lng": position.longitude}
      });
    } catch (e) {
      logInfo('Error: $e');
      return null;
    }
  }

  clearMessages() {
    messages.clear();
  }

  cancelStream() {
    messageStream.cancel();
  }
}
