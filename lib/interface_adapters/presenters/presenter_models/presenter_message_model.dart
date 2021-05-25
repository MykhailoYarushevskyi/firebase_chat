import 'package:firebase_chat/domain/entities/massage_models/massage_model.dart';

typedef Json = Map<String, dynamic>;

class PresenterMessageModel extends MessageModel {
  PresenterMessageModel({
    required String messageId,
    required String userId,
    required String userName,
    required int dateTimeMessage,
    String imageUrl = '',
    String textMessage = '',
  }) : super(
            messageId: messageId,
            userId: userId,
            userName: userName,
            dateTimeMessage: dateTimeMessage,
            imageUrl: imageUrl,
            textMessage: textMessage);
  factory PresenterMessageModel.fromJson(String messageId, Json data) {
    return PresenterMessageModel(
      messageId: messageId,
      userId: data['userId'] as String,
      userName: data['userName'] as String,
      dateTimeMessage: data['date_time_message'] as int,
      imageUrl: data['imageUrl'] as String,
      textMessage: data['text'] as String,
    );
  }

  factory PresenterMessageModel.fromModel(MessageModel model) {
    return PresenterMessageModel(
      messageId: model.messageId,
      userId: model.userId,
      userName: model.userName,
      dateTimeMessage: model.dateTimeMessage,
      imageUrl: model.imageUrl,
      textMessage: model.textMessage,
    );
  }

  Json toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'date_time_message': dateTimeMessage,
      'imageUrl': imageUrl,
      'text': textMessage
    };
  }
}
