import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat/interface_adapters/repositories/soources_abstr/web/firebase/massages_firestore_service.dart';

/// For creating, reading, updating, deleting messages in Firebase Firestore
class MessagesFirestoreServiceImpl implements MessagesFirestoreService {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final _collectionPath = 'chat';

  /// returns the stream of messages that ordered by [date_time_message] field
  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getStreamMessagesService() {
    return firestore
        .collection(_collectionPath)
        .orderBy('date_time_message', descending: true)
        .snapshots();
  }

  /// adds the [document] (message) to the [collection] (messages)
  @override
  Future<void> addMessageService(Map<String, dynamic> data) async {
    try {
      await firestore.collection(_collectionPath).add(data);
    } catch (error) {
      rethrow;
    }
  }

  /// deletes the [document] (message) from the [collection] (messages)
  @override
  Future<void> deleteMessageService(String documentId) async {
    try {
      await firestore.collection(_collectionPath).doc(documentId).delete();
    } catch (error) {
      rethrow;
    }
  }
}