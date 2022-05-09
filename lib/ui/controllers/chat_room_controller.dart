import 'package:chat_app/models/message.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import './crypto_controller.dart';

class ChatRoomController extends GetxController {
  var messages = <Message>[].obs;
  var uuid = const Uuid();
  final databaseRef = FirebaseDatabase.instance.ref('chats');
  final crypto = CryptoController();

  var messageStream;

  fetchChatMessages(chatId) {
    messageStream = databaseRef
        .child('$chatId/messages')
        .orderByChild('timestamp')
        .onChildAdded
        .listen((DatabaseEvent event) async {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      var message = Message(
          event.snapshot.key,
          data['senderId'],
          data['receiverId'],
          data['timestamp'],
          data['cipherText'],
          data['nonce']);
      message.content = await crypto.decrypt(message, 'casade16casade16');
      print(message.content);
      messages.add(message);
    });
  }

  sendMessage(chatId, senderId, receiverId, content) async {
    final messageId = uuid.v4();
    try {
      var messageTimestamp = DateTime.now().millisecondsSinceEpoch;
      var encryptedMessage = await crypto.encrypt(content, 'casade16casade16');
      await FirebaseDatabase.instance
          .ref('chats/$chatId/messages/$messageId')
          .set({
        "senderId": senderId,
        "receiverId": receiverId,
        "nonce": encryptedMessage.nonce.toString(),
        "cipherText": encryptedMessage.cipherText.toString(),
        "timestamp": messageTimestamp
      });
    } catch (e) {
      print('Error : $e');
      return null;
    }
  }

  createMessages(chatId, currentUserId, receiverId, receiverEmail) async {
    String name = receiverEmail.substring(0, receiverEmail.indexOf('@'));
    String messageOne = 'Hola! mi nombre es $name.';
    String messageTwo = 'Hola $name, mucho gusto.';

    var snapshot = await databaseRef.child('$chatId/messages').get();
    if (snapshot.exists) return;

    await sendMessage(chatId, receiverId, currentUserId, messageOne);
    await sendMessage(chatId, currentUserId, receiverId, messageTwo);
  }

  clearMessages() {
    messages.clear();
  }

  cancelStream() {
    messageStream.cancel();
  }
}
