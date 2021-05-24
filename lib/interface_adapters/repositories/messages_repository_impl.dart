import 'package:firebase_chat/domain/use_cases/adapters_abstr/repositories/messages_repository.dart';
import 'package:firebase_chat/interface_adapters/repositories/repository_models/repository_message_model.dart';
import 'package:firebase_chat/interface_adapters/repositories/soources_abstr/web/firebase/massages_firestore_service.dart';

class MessagesRepositoryImpl implements MessagesRepository {
  final MessagesFirestoreService messagesFirestoreService;

  MessagesRepositoryImpl(this.messagesFirestoreService);

  /// returns the stream of messages that ordered by [date_time_message] field
  @override
  Stream<List<RepositoryMessageModel>> getStreamMessagesRepo() {
    final streamQuerySnapshot =
        messagesFirestoreService.getStreamMessagesService();
    final Stream<List<RepositoryMessageModel>> messagesStream =
        streamQuerySnapshot.map<List<RepositoryMessageModel>>((querySnapshot) =>
            querySnapshot.docs
                .map<RepositoryMessageModel>((queryDocumentSnapshot) =>
                    convertMapToModel(queryDocumentSnapshot.data()))
                .toList());
    return messagesStream;
  }

  /// converts [Map<String, dynamic>] to the PresenterMessageModel object
  RepositoryMessageModel convertMapToModel(Map<String, dynamic> data) {
    return RepositoryMessageModel.fromJson(data);
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
  Future<void> deleteMessageRepo(String documentId) async {
    try {
      await messagesFirestoreService.deleteMessageService(documentId);
    } catch (error) {
      rethrow;
    }
  }
}
