
class MessageModel {
  final String messageId;
  final int dateTimeMessage;
  final String userId;
  final String userName;
  final String textMessage;
  final String imageUrl;

  MessageModel({
    required this.messageId,
    required this.userId,
    required this.dateTimeMessage,
    required this.userName,
    this.imageUrl = '',
    this.textMessage = '',
  });
}