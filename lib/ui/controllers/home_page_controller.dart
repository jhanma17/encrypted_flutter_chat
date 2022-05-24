import 'dart:developer';

import 'package:chat_app/models/user.dart';
import 'package:chat_app/ui/controllers/authentication_controller.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';
import 'package:uuid/uuid.dart';

class HomePageController extends GetxController {
  var users = <ChatUser>[].obs;
  final uuid = const Uuid();

  final usersRef = FirebaseDatabase.instance.ref('users');
  final chatsRef = FirebaseDatabase.instance.ref('chats');

  createChat(senderId, receiverId) async {
    final chatId = uuid.v4();
    receiverId = await receiverId;
    try {
      await chatsRef.child('$chatId/participants').set({
        0: senderId,
        1: receiverId,
      });
      log('senderId: ' + senderId);
      log('receiverId: ' + receiverId);
      return chatId;
    } catch (e) {
      logInfo('Error creating chat: $e');
      return null;
    }
  }

  getChatId(senderId, receiverId) async {
    final snapshots = await chatsRef.get();

    if (!snapshots.exists) {
      return createChat(senderId, receiverId);
    }

    for (var snap in snapshots.children) {
      final data = snap.value as Map<dynamic, dynamic>;
      final participants = data['participants'] as List;
      var validChat = false;
      if (participants[0] == senderId && participants[1] == receiverId) {
        validChat = true;
      } else if (participants[0] == receiverId && participants[1] == senderId) {
        validChat = true;
      }

      if (validChat) {
        log("chat already exists");
        return snap.key;
      }
    }

    return createChat(senderId, receiverId);
  }

  fetchChatUsers(currentUserId) async {
    final chats = await chatsRef.get();
    if (!chats.exists) {
      return;
    }
    var data = chats.value as Map<dynamic, dynamic>;
    for (var key in data.keys) {
      final participants = data[key]['participants'] as List;
      if (participants[0] == currentUserId ||
          participants[1] == currentUserId) {
        final senderId = participants[0];
        final receiverId = participants[1];
        log("sender user: $senderId");
        log("reciver user: $receiverId");
        if (currentUserId == senderId) {
          var email = await AuthenticationController().getEmailById(receiverId);
          final name = await usersRef.child(receiverId).get();
          var nameString = email;
          var image = '';
          if (name.value != null) {
            var namevalue = name.value as Map<dynamic, dynamic>;
            nameString = namevalue['name'];
            image = namevalue['image'] == null ? '' : namevalue['image'];
          }
          users.add(ChatUser(receiverId, nameString, email, image));
        } else {
          var email = await AuthenticationController().getEmailById(senderId);
          final name = await usersRef.child(senderId).get();
          var nameString = email;
          var image = '';
          if (name.value != null) {
            var namevalue = name.value as Map<dynamic, dynamic>;
            nameString = namevalue['name'];
            image = namevalue['image'] == null ? '' : namevalue['image'];
          }
          users.add(ChatUser(senderId, nameString, email, image));
        }
      }
    }
  }

  fetchUser(userId) async {
    var snapshot = await usersRef.child(userId).get();
    if (snapshot.exists) {
      return snapshot.value;
    }
  }

  cleanChatRoom() {
    log('cleanChatRoom');
    users.clear();
  }
}
