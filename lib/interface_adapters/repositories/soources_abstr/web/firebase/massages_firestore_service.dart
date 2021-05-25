import 'package:cloud_firestore/cloud_firestore.dart';

abstract class MessagesFirestoreService {
  /// returns the stream of messages ordered by [date_time_message] field from the Firestore
  Stream<QuerySnapshot<Map<String, dynamic>>> getStreamMessagesService();

  /// adds the [document] (message) to the [collection] (messages)
  Future<void> addMessageService(Map<String, dynamic> data);

  /// deletes the [document] (message) from the [collection] (messages)
  Future<void> deleteMessageService(String documentId);

  /// updates the [document] (message) in the [collection] (messages)
  Future<void> updateMessageService(
      String documentId, Map<String, dynamic> data);
}
