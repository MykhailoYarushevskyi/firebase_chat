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

  Future<void> uploadProfileImageByUserId(
    String userId,
    File profileImageFile,
  ) async {
    await getReferenceProfileImageFile(userId).putFile(profileImageFile);
  }

  Future<String> getUrlProfileImageFile(String userId) {
    return getReferenceProfileImageFile(userId).getDownloadURL();
  }

  Future<List<Reference>> getReferencesProfileImageFiles() async {
    final result =
        await FirebaseStorage.instance.ref().child('profile-images').listAll();
    return result.items;
  }

  Future<List<String>> getListUrlProfileImageFiles() async {
    final List<String> listUrl = [];
    try {
      final listReference = await getReferencesProfileImageFiles();
      // ignore: avoid_function_literals_in_foreach_calls
      listReference.forEach((ref) async {
        listUrl.add(await ref.getDownloadURL());
      });
    } catch (error) {
      rethrow;
    }
    return listUrl;
  }
}
