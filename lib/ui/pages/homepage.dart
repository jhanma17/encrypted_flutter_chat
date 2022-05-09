import 'package:chat_app/ui/controllers/home_page_controller.dart';
import 'package:chat_app/ui/controllers/chat_room_controller.dart';
import 'package:chat_app/ui/pages/chat.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';

import '../controllers/authentication_controller.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  final AuthenticationController authenticationController = Get.find();
  final HomePageController chatController = Get.find();
  final ChatRoomController chatRoomController = Get.find();

  _logout() async {
    try {
      await authenticationController.logout();
    } catch (e) {
      logError(e);
    }
  }

  _createChatsAndMessages() async {
    final currentId = authenticationController.getUid();
    for (var user in chatController.users) {
      if (user.id == currentId) continue;

      final chatId = await chatController.getChatId(currentId, user.id);
      await chatRoomController.createMessages(
          chatId, currentId, user.id, user.email);
    }
  }

  @override
  Widget build(BuildContext context) {
    chatController.fetchChatUsers(authenticationController.getUid());

    return Scaffold(
        appBar: AppBar(
          title: const Text("Secret chatter"),
          actions: [
            IconButton(
                icon: const Icon(Icons.exit_to_app),
                onPressed: () {
                  chatController.cleanChatRoom();
                  _logout();
                }),
          ],
        ),
        body: SafeArea(
          child: Obx(() => ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: chatController.users.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                      onTap: () async {
                        var chatId = await chatController.getChatId(
                            authenticationController.getUid(),
                            chatController.users[index].id);

                        if (chatId != null) {
                          Get.to(ChatRoomPage(
                            receiverEmail: chatController.users[index].email,
                            chatId: chatId,
                            receiverId: chatController.users[index].id,
                          ));
                        }
                      },
                      child: Card(
                          child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(chatController.users[index].email),
                      )));
                },
              )),
        ));
  }
}
