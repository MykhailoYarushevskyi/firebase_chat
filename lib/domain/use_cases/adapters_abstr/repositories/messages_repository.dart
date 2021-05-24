import 'package:firebase_chat/interface_adapters/repositories/repository_models/repository_message_model.dart';

abstract class MessagesRepository {

  Stream<List<RepositoryMessageModel>> getStreamMessagesRepo();

  Future<void> addMessageRepo(Map<String, dynamic> data);

  /// deletes the message from the messages
  Future<void> deleteMessageRepo(String documentId);
}
