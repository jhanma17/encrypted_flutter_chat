import 'dart:developer';
import 'dart:io';
import 'package:chat_app/ui/controllers/home_page_controller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImageController extends GetxController {
  final storageRef = FirebaseStorage.instance;
  final auth = FirebaseAuth.instance;
  final userRef = FirebaseDatabase.instance.ref('users');
  var image = '';

  Future<String> uploadImage(File image) async {
    var userId = auth.currentUser!.uid;
    var imageName = userId + '.jpg';
    var ref = storageRef.ref().child(imageName);
    var uploadTask = ref.putFile(image);
    var completed = await uploadTask.whenComplete(() => {
          log('Image uploaded'),
          ref.getDownloadURL().then((url) => {
                userRef.child(userId).update({'image': url}),
              })
        });
    return '';
  }

  Future<void> getImages() async {
    for (var user in HomePageController().users) {
      var ref = storageRef.ref().child(user.id + '.jpg');
      var url = await ref.getDownloadURL();
    }
  }

  Future<String> getImage(id) async {
    var ref = storageRef.ref().child(id + '.jpg');
    var url = await ref.getDownloadURL();
    image = url;
    return url;
  }
}
