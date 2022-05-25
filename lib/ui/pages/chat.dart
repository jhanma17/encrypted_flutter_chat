import 'dart:developer';

import 'package:chat_app/ui/controllers/authentication_controller.dart';
import 'package:chat_app/ui/controllers/chat_room_controller.dart';
import 'package:chat_app/ui/pages/temp_map.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chat_app/models/message.dart';

class ChatRoomPage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final AuthenticationController authenticationController = Get.find();
  final ChatRoomController chatRoomController = Get.find();

  final String receiverEmail;
  final String receiverId;
  final String chatId;
  // TODO: Get this key in front
  // It must be 16 character long
  final String keyPhrase;

  final Color _receiverColor = const Color.fromARGB(255, 234, 237, 255);
  final Color _senderColor = const Color.fromARGB(255, 243, 243, 243);

  ChatRoomPage(
      {Key? key,
      required this.receiverEmail,
      required this.receiverId,
      required this.chatId,
      required this.keyPhrase})
      : super(key: key);

  _sendMessage(content) async {
    final currentUserId = authenticationController.getUid();
    await chatRoomController.sendMessage(
        chatId, currentUserId, receiverId, content, keyPhrase);
  }

  Widget _textInput() {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                margin: const EdgeInsets.only(left: 5.0, top: 5.0),
                child: TextField(
                  key: const Key('MsgTextField'),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Your message',
                  ),
                  onSubmitted: (value) {
                    _sendMessage(value);
                    _controller.clear();
                  },
                  controller: _controller,
                ),
              ),
            ),
            TextButton(
                key: const Key('sendButton'),
                child: const Text('Send'),
                onPressed: () {
                  _sendMessage(_controller.text);
                  _controller.clear();
                })
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    chatRoomController.clearMessages();
    chatRoomController.fetchChatMessages(chatId, keyPhrase);
    chatRoomController.initPos();

    return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            color: Colors.white,
            onPressed: () {
              chatRoomController.cancelStream();
              Navigator.pop(context, true);
            },
          ),
          title: Text("Chat with $receiverEmail"),
        ),
        body: SafeArea(
            child: Column(
          children: [
            Expanded(
              flex: 4,
              child: Obx(() => ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: chatRoomController.messages.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: isMyMessage(chatRoomController.messages[index])
                            ? _senderColor
                            : _receiverColor,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: GestureDetector(
                              onTap: () {
                                double lat = chatRoomController
                                    .messages[index].location.lat;
                                double lng = chatRoomController
                                    .messages[index].location.lng;
                                TempMap map = TempMap(lat: lat, lng: lng);
                                Get.to(map);
                              },
                              child: Column(
                                crossAxisAlignment: isMyMessage(
                                        chatRoomController.messages[index])
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      chatRoomController
                                          .messages[index].content,
                                      textAlign: TextAlign.left),
                                  Text(
                                      chatRoomController
                                          .messages[index].ipAddress,
                                      style: const TextStyle(fontSize: 10),
                                      textAlign: TextAlign.left),
                                  Text(
                                      chatRoomController
                                              .messages[index].device.model +
                                          ', ' +
                                          chatRoomController
                                              .messages[index].device.device,
                                      style: const TextStyle(fontSize: 10),
                                      textAlign: TextAlign.left)
                                ],
                              )),
                        ),
                      );
                    },
                  )),
            ),
            _textInput()
          ],
        )));
  }

  isMyMessage(Message message) {
    if (message.senderId == authenticationController.getUid()) return true;

    return false;
  }
}
