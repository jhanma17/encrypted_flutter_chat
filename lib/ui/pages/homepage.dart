import 'dart:developer';

import 'package:chat_app/ui/controllers/home_page_controller.dart';
import 'package:chat_app/ui/controllers/chat_room_controller.dart';
import 'package:chat_app/ui/pages/chat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';
import '../controllers/authentication_controller.dart';
import '../controllers/image_controller.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthenticationController authenticationController = Get.find();

  final HomePageController chatController = Get.find();

  final ChatRoomController chatRoomController = Get.find();

  final ImageController imageController = Get.find();

  String busqueda = '';

  String emailToCreateChat = '';

  Widget searchBar = const Text("Secret Chatter");

  Icon searchIcon = const Icon(Icons.search);

  List messages = [];

  bool loaded = false;
  _logout() async {
    try {
      await authenticationController.logout();
    } catch (e) {
      logError(e);
    }
  }

  List buscar(String busqueda) {
    // return users that match the busqueda
    var users = chatController.users;
    var result = [];
    for (var user in users) {
      if (user.name.toLowerCase().contains(busqueda.toLowerCase())) {
        result.add(user);
      }
    }
    return result;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) async => {
          await chatController.cleanChatRoom(),
          await chatController.fetchChatUsers(authenticationController.getUid())
        });

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: searchBar,
          leading: IconButton(
              icon: searchIcon,
              onPressed: () {
                setState(() {
                  if (searchIcon.icon == Icons.search) {
                    searchBar = TextField(
                      onChanged: (value) {
                        chatController.cleanChatRoom();
                        setState(() {
                          busqueda = value;
                        });
                      },
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search',
                        hintStyle: TextStyle(
                            fontFamily: 'Poppins', color: Colors.white),
                      ),
                      style: const TextStyle(
                          fontSize: 20,
                          fontFamily: 'Poppins',
                          color: Colors.white),
                    );
                    searchIcon = Icon(Icons.cancel);
                  } else {
                    searchBar = const Text("Secret Chatter");
                    searchIcon = const Icon(Icons.search);
                    busqueda = '';
                  }
                });
              }),
          actions: [
            IconButton(
                icon: const Icon(Icons.exit_to_app),
                onPressed: () {
                  chatController.cleanChatRoom();
                  _logout();
                }),
            IconButton(
                icon: const Icon(Icons.person_outlined),
                onPressed: () {
                  chatController.cleanChatRoom();
                  Get.toNamed('/profile');
                }),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Create a new chat"),
                    content: TextField(
                      onChanged: (value) {
                        emailToCreateChat = value;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Email',
                        hintStyle: TextStyle(
                            fontFamily: 'Poppins', color: Colors.black),
                      ),
                      style: const TextStyle(
                          fontSize: 20,
                          fontFamily: 'Poppins',
                          color: Colors.black),
                    ),
                    actions: [
                      FlatButton(
                        child: const Text("Cancel"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      FlatButton(
                        child: const Text("Create"),
                        onPressed: () async {
                          chatController.cleanChatRoom();
                          Navigator.of(context).pop();
                          await chatController.getChatId(
                              authenticationController.getUid(),
                              authenticationController
                                  .getIdByEmail(emailToCreateChat));
                          await chatController.fetchChatUsers(
                              authenticationController.getUid());
                        },
                      ),
                    ],
                  );
                });
          },
          child: const Icon(Icons.add),
        ),
        body: SafeArea(
          child: Obx(() => ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: buscar(busqueda).length,
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
                            keyPhrase: "casade16casade16",
                          ));
                        }
                      },
                      child: Card(
                          child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Container(
                                child: Column(children: [
                                  Row(children: [
                                    Container(
                                        width: 40.0,
                                        height: 40.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              image: chatController
                                                          .users[index].image !=
                                                      ''
                                                  ? NetworkImage(chatController
                                                      .users[index].image)
                                                  : NetworkImage(
                                                          'https://img.blogs.es/anexom/wp-content/uploads/2020/06/pestana-de-incognito-navegacion-oculta.jpg')
                                                      as ImageProvider),
                                        )),
                                    Text(chatController.users[index].name,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold))
                                  ]),
                                ]),
                              ))));
                },
              )),
        ));
  }
}
