import 'dart:developer';

import 'package:firebase_chat/domain/entities/massage_models/massage_model.dart';
import 'package:firebase_chat/domain/use_cases/adapters_abstr/repositories/messages_repository.dart';

class MessagesUseCase {
  MessagesUseCase(this.repository);
  final MessagesRepositoryAbstr repository;

  /// returns the stream of messages that ordered by the [date_time_message] field
  Stream<List<MessageModel>> getStreamMessagesUseCase() {
    return repository.getStreamMessagesRepo();
  }

  /// adds the message to the the source
  Future<void> addMessageUseCase(Map<String, dynamic> data) async {
    try {
      await repository.addMessageRepo(data);
    } catch (error) {
      rethrow;
    }
  }

  /// updates the message on the message at the source
  Future<void> updateMessageUseCase(
      String messageId, Map<String, dynamic> data) async {
    try {
      await repository.updateMessageRepo(messageId, data);
    } catch (error) {
      rethrow;
    }
  }

  /// deletes the message from the messages
  Future<void> deleteMessageUseCase(String messageId) async {
    log('## MessagesUseCase.deleteMessageUseCase($messageId) ');
    try {
      await repository.deleteMessageRepo(messageId);
    } catch (error) {
      rethrow;
    }
  }
}
