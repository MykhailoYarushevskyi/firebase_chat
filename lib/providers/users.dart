import 'package:flutter/cupertino.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class Users with ChangeNotifier {
  static const String MAIN_TAG = '## Users';
  final String usersPath = 'users';

  Future<void> saveUserData({
    userId,
    userEmail,
    userPassword,
    userName,
  }) async {
    try {
      print('$MAIN_TAG Entrance userId: $userId');
      await FirebaseFirestore.instance.collection(usersPath).doc(userId).set({
        'email': userEmail,
        'password': userPassword,
        'name': userName,
      });
    } catch (e) {
      throw e;
    }
  }

  Future<String> getUserName(userId) async {
    try {
      DocumentSnapshot doc;
      doc = await FirebaseFirestore.instance
          .collection(usersPath)
          .doc(userId)
          .get();
      // .then((value) {
      // doc = value;
      final docData = doc.data();
      print(
          '$MAIN_TAG getUserName userId: $userId; docData[name]: ${docData['name']}');
      return docData['name'] as String;
      // });
    } on FirebaseException catch (error) {
      throw error;
    } catch (error) {
      throw error;
    }
  }
}
