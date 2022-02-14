import 'dart:developer';

import 'package:firebase_chat/domain/use_cases/adapters_abstr/repositories/messages_repository.dart';
import 'package:firebase_chat/interface_adapters/repositories/repository_models/repository_message_model.dart';
import 'package:firebase_chat/interface_adapters/repositories/soources_abstr/firebase/massages_firestore_service_abstr.dart';

class MessagesRepository implements MessagesRepositoryAbstr {
  static const String mainTag = '## MessagesRepository';
  final MessagesFirestoreServiceAbstr messagesFirestoreService;

  MessagesRepository(this.messagesFirestoreService);

  /// returns the stream of messages that ordered by [date_time_message] field
  @override
  Stream<List<RepositoryMessageModel>> getStreamMessagesRepo() {
    final streamQuerySnapshot =
        messagesFirestoreService.getStreamMessagesService();
    final Stream<List<RepositoryMessageModel>> messagesStream =
        streamQuerySnapshot.map<List<RepositoryMessageModel>>((querySnapshot) =>
            querySnapshot.docs
                .map<RepositoryMessageModel>((queryDocumentSnapshot) {
              final messageId = queryDocumentSnapshot.id;
              return convertIdAndMapToModel(messageId, queryDocumentSnapshot.data());
            }).toList());
    return messagesStream;
  }

  /// adds mesaageId to the [data] and converts [Map<String, dynamic>] to the PresenterMessageModel object
  RepositoryMessageModel convertIdAndMapToModel(
      String messageId, Map<String, dynamic> data) {
    return RepositoryMessageModel.fromIdAndJson(messageId, data);
  }

  /// adds the message to the Firestore
  @override
  Future<void> addMessageRepo(Map<String, dynamic> data) async {
    try {
      await messagesFirestoreService.addMessageService(data);
    } catch (error) {
      rethrow;
    }
  }

  /// deletes the message from the messages
  @override
  Future<void> deleteMessageRepo(String messageId) async {
    try {
      await messagesFirestoreService.deleteMessageService(messageId);
    } catch (error) {
      rethrow;
    }
  }

  /// updates the message on the messages
  @override
  Future<void> updateMessageRepo(
      String messageId, Map<String, dynamic> data) async {
    try {
      await messagesFirestoreService.updateMessageService(messageId, data);
    } catch (error) {
      rethrow;
    }
  }
}
