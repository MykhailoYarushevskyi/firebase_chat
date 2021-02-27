import 'package:flutter/cupertino.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../helpers/delegate_exception.dart';

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
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection(usersPath)
          .doc(userId)
          .get();
      // Gets a nested field by [String] or [FieldPath] from this
      // [DocumentSnapshot], using [dynamic operator [](dynamic field) => get(field);]
      // We could also use [final docDataMap = doc.data();] where the 
      // [docDataMap] is a [Map<String, dynamic>],
      // and [return docDataMap['name'] as String;],
      final String userName = doc['name'];
      print('$MAIN_TAG getUserName userId: $userId; userName: $userName');
      return userName;
    } on FirebaseException catch (error) {
      throw DelegateException(
        message: error.message,
        plugin: error.plugin,
        code: error.code,
        stackTrace: error.stackTrace,
      );
    } catch (error) {
      throw error;
    }
  }
}
