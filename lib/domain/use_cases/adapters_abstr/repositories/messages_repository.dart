import 'package:firebase_chat/interface_adapters/repositories/repository_models/repository_message_model.dart';

abstract class MessagesRepositoryAbstr {
  /// returns the stream of messages
  Stream<List<RepositoryMessageModel>> getStreamMessagesRepo();

  /// adds the message to the source
  Future<void> addMessageRepo(Map<String, dynamic> data);

  /// deletes the message from the messages
  Future<void> deleteMessageRepo(String messageId);

  /// updates the message on the messages
  Future<void> updateMessageRepo(String messageId, Map<String, dynamic> data);
}
