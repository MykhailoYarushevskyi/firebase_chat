import 'dart:io';

import 'package:flutter/cupertino.dart';

import 'package:firebase_storage/firebase_storage.dart';

class ProfileImages with ChangeNotifier {
  List<String> images = [];

  Reference getReferenceProfileImageFile(String userId) {
    return FirebaseStorage.instance
        .ref()
        .child('profile-images')
        .child('$userId.jpg');
  }

  Future<void> uploadImageByUserId(
    String userId,
    File profileImageFile,
  ) async {
    await getReferenceProfileImageFile(userId).putFile(profileImageFile);
  }

  Future<String> getUrlProfileImageFile(String userId) async {
    return await getReferenceProfileImageFile(userId).getDownloadURL();
  }

  Future<List<Reference>> getReferencesProfileImageFiles() async {
    var result =
        await FirebaseStorage.instance.ref().child('profile-images').listAll();
    return result.items;
  }

  Future<List<String>> getListUrlProfileImageFiles() async {
    List<String> listUrl = [];
    try {
      var listReference = await getReferencesProfileImageFiles();
      listReference.forEach((ref) async {
        listUrl.add(await ref.getDownloadURL());
      });
    } catch (error) {
      throw error;
    }
    return listUrl;
  }
}
