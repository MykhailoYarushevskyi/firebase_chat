import 'dart:async';

import 'package:flutter/cupertino.dart';

import 'package:firebase_chat/app/service_locator.dart';
import 'package:firebase_chat/domain/entities/massage_models/massage_model.dart';
import 'package:firebase_chat/domain/use_cases/messages_use_cases/messages_use_case.dart';
import 'package:firebase_chat/interface_adapters/presenters/presenter_models/presenter_message_model.dart';

class Messages with ChangeNotifier {
  static const String mainTag = '## Messages';

  final MessagesUseCase _messagesUseCase = getIt.get<MessagesUseCase>();

  /// It will be called in the builder of the ChangeNotifierProxyProvider<Auth, Messages>,
  /// in the main() method.
  /// updates fields that depend on the Auth class.
  void update() {}

  //TODO! order the List<PresenterMessageModel> by the dateTimeMessage field of the PresenterMessageModel
  /// returns the stream of messages that ordered by [dateTimeMessage] field of the PresenterMessageModel
  Stream<List<PresenterMessageModel>> getMessages() {
    return convertModelToPresentModel(
        _messagesUseCase.getStreamMessagesUseCase());
  }

  Stream<List<PresenterMessageModel>> convertModelToPresentModel(
      Stream<List<MessageModel>> stream) {
    return stream.map((event) =>
        event.map((model) => PresenterMessageModel.fromModel(model)).toList());
  }

  /// adds the [document] (message) to the [collection] (messages)
  Future<void> addMessage(Map<String, dynamic> data) async {
    try {
      await _messagesUseCase.addMessageUseCase(data);
    } catch (error) {
      rethrow;
    }
  }

  /// deletes the [document] (message) from the [collection] (messages)
  Future<void> deleteMessage(String messageId) async {
    try {
      await _messagesUseCase.deleteMessageUseCase(messageId);
    } catch (error) {
      rethrow;
    }
  }
}