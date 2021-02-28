import 'package:flutter/cupertino.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class Messages with ChangeNotifier {
  static const String MAIN_TAG = '## Messages';
  // one instance of the Firestore for all instances of the Message
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final collectionPath = 'chat';

  /// method updates fields that depend on the Auth class or an another class,
  /// will be called in ChangeNotifierProxyProvider<Auth, Messages>
  /// im main().
  void update() {}

  /// return the stream of messages that ordered by [date_time_message] field
  Stream<QuerySnapshot> streamMessages() {
    return firestore
        .collection(collectionPath)
        .orderBy('date_time_message', descending: true)
        .snapshots();
  }

  /// method adds [document] (message) to the [collection] (messages)
  Future<void> addMessage(Map<String, dynamic> data) async {
    try {
      await firestore.collection(collectionPath).add(data);
    } catch (error) {
      throw error;
    }
  }

  /// method deletes [document] (message) from the [collection] (messages)
  Future<void> deleteMessage(String documentId) async {
    try {
      await firestore.collection(collectionPath).doc(documentId).delete();
    } catch (error) {
      throw error;
    }
  }
}
