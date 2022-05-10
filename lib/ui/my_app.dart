import 'package:chat_app/ui/controllers/chat_room_controller.dart';
import 'package:chat_app/ui/pages/homepage.dart';
import 'package:chat_app/ui/pages/login.dart';
import 'package:chat_app/ui/pages/signup.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/authentication_controller.dart';
import 'controllers/home_page_controller.dart';
import './firebase_central.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(HomePageController());
    Get.put(AuthenticationController());
    Get.put(ChatRoomController());

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Secret Chatter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const FirebaseCentral()),
        GetPage(name: '/login', page: () => const LoginPage()),
        GetPage(name: '/signup', page: () => const Signup()),
        GetPage(name: '/home', page: () => HomePage())
      ],
    );
  }
}
