import 'package:firebase_chat/domain/entities/massage_models/massage_model.dart';

typedef Json = Map<String, dynamic>;

class RepositoryMessageModel extends MessageModel {
  RepositoryMessageModel({
    required String userId,
    required int dateTimeMessage,
    required String userName,
    String imageUrl = '',
    String textMessage = '',
  }) : super(
            dateTimeMessage: dateTimeMessage,
            userId: userId,
            userName: userName,
            imageUrl: imageUrl,
            textMessage: textMessage);
  factory RepositoryMessageModel.fromJson(Json data) {
    return RepositoryMessageModel(
      userId: data['userId'] as String,
      userName: data['userName'] as String,
      dateTimeMessage: data['date_time_message'] as int,
      imageUrl: data['imageUrl'] as String,
      textMessage: data['text'] as String,
    );
  }
}
