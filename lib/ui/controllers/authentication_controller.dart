import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

import 'package:chat_app/models/user.dart';

class AuthenticationController extends GetxController {
  Future<void> login(email, password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return Future.error("User not found");
      } else if (e.code == 'wrong-password') {
        return Future.error("Wrong password");
      }
      return Future.error('Something went wrong at login');
    }
  }

  Future<void> signup(email, password, name) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      var uid = credential.user?.uid;
      await FirebaseDatabase.instance
          .ref('users/$uid')
          .set({"email": email, "name": name});
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return Future.error("The password is too weak");
      } else if (e.code == 'email-already-in-use') {
        return Future.error("The email is taken");
      }

      return Future.error('Something went wrong at signup');
    }
  }

  logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      return Future.error("Logout error");
    }
  }

  String getUserEmail() {
    String email = FirebaseAuth.instance.currentUser!.email ?? "a@a.com";
    return email;
  }

  String getUid() {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    return uid;
  }

  String getUserName() {
    String name = "";
    return name;
  }

  Future<String> getIdByEmail(String email) async {
    final snapshot = await FirebaseDatabase.instance.ref().child('users').get();
    if (snapshot.exists) {
      if (snapshot.value != null) {
        var users = snapshot.value as Map<dynamic, dynamic>;
        for (var key in users.keys) {
          log("key: $key");
          if (users[key]['email'] == email) {
            return key.toString();
          }
        }
      }
    } else {
      log('No data available.');
    }
    return "";
  }

  Future<String> getEmailById(String id) async {
    final snapshot = await FirebaseDatabase.instance.ref().child('users').get();
    if (snapshot.exists) {
      if (snapshot.value != null) {
        var users = snapshot.value as Map<dynamic, dynamic>;
        for (var key in users.keys) {
          if (key == id) {
            return users[key]['email'];
          }
        }
      }
    } else {
      log('No data available.');
    }
    return "";
  }
}
