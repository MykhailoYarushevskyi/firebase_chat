import 'package:firebase_chat/domain/entities/massage_models/massage_model.dart';

typedef Json = Map<String, dynamic>;

class PresenterMessageModel extends MessageModel {
  PresenterMessageModel({
    required String userId,
    required String userName,
    required int dateTimeMessage,
    String imageUrl = '',
    String textMessage = '',
  }) : super(
            userId: userId,
            userName: userName,
            dateTimeMessage: dateTimeMessage,
            imageUrl: imageUrl,
            textMessage: textMessage);
  factory PresenterMessageModel.fromJson(Json data) {
    return PresenterMessageModel(
      userId: data['userId'] as String,
      userName: data['userName'] as String,
      dateTimeMessage: data['date_time_message'] as int,
      imageUrl: data['imageUrl'] as String,
      textMessage: data['text'] as String,
    );
  }

  factory PresenterMessageModel.fromModel(MessageModel model) {
    return PresenterMessageModel(
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
