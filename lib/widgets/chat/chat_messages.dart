import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../providers/messages.dart';
import '../../providers/auth.dart';

class ChatMessages extends StatelessWidget {
  static const String MAIN_TAG = '## ChatMessages';
  final localeString = 'uk';

  @override
  Widget build(BuildContext context) {
    final double _deviceWidth = MediaQuery.of(context).size.width;
    final messagesInstance = Provider.of<Messages>(context, listen: false);
    final currentUserId = Provider.of<Auth>(context, listen: false).userId;
    List<DocumentSnapshot> _messages;
    return StreamBuilder<QuerySnapshot>(
        stream: messagesInstance.streamMessages(),
        builder: (context, streamSnapshot) {
          if (streamSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          _messages = getMessages(streamSnapshot);
          return !streamSnapshot.hasData || _messages == null
              ? Container(width: 0.0, height: 0.0)
              : ListView.separated(
                  reverse: true,
                  itemCount: _messages.length,
                  separatorBuilder: (ctx, index) =>
                      _buildListSeparator(_messages, index),
                  itemBuilder: (ctx, index) {
                    final messageUserId =
                        _messages[index].data()['userId'] as String;
                    bool isMyMessage = messageUserId == currentUserId;
                    return _buildListItem(
                        _messages, index, isMyMessage, _deviceWidth);
                  });
        });
  }

  /// the method returns the list of messages [DocumentSnapshot].
  List<DocumentSnapshot> getMessages(
      AsyncSnapshot<QuerySnapshot> streamSnapshot) {
    List<DocumentSnapshot> messages;
    if (streamSnapshot.hasData) {
      messages = streamSnapshot.data.docs;
      if (messages != null) {
        messages.where((item) => item['date_time_message'] != null).toList();
      }
    }
    return messages;
  }

  /// the method builds a Widget that contains the user's message
  Widget _buildListItem(
    List<DocumentSnapshot> messages,
    int index,
    bool isMyMessage,
    double deviceWidth,
  ) {
    if (index == messages.length - 1) {
      return Column(
        children: [
          _buildSeparatorWidget(messages, index),
          _buildItemWidget(messages, index, isMyMessage, deviceWidth)
        ],
      );
    } else {
      return _buildItemWidget(
        messages,
        index,
        isMyMessage,
        deviceWidth,
      );
    }
  }

  /// the method returns the list item's widget
  Widget _buildItemWidget(
    List<DocumentSnapshot> messages,
    int index,
    bool isMyMessage,
    double deviceWidth,
  ) {
    return Align(
      alignment: isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 10.0,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 10.0,
        ),
        // TODO Maybe would try to choose the width
        // if the real width of this widget will less than the computation
        width: deviceWidth * 0.6,
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: isMyMessage
              ? BorderRadius.only(
                  bottomLeft: Radius.circular(18.0),
                  bottomRight: Radius.zero,
                  topLeft: Radius.circular(18.0),
                  topRight: Radius.circular(18.0),
                )
              : BorderRadius.only(
                  bottomLeft: Radius.zero,
                  bottomRight: Radius.circular(18.0),
                  topLeft: Radius.circular(18.0),
                  topRight: Radius.circular(18.0),
                ),
          color: isMyMessage ? Colors.lightBlue[50] : Colors.grey[200],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              // We get a nested field by [String] or [FieldPath] from this
              // [DocumentSnapshot], using [dynamic operator [](dynamic field) => get(field);]
              // We could also use [messages[index].doc.data()['userName'];] where the
              // [doc.data() returns a [Map<String, dynamic>]
              messages[index]['userName'],
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(messages[index]['text'].toString()),
          ],
        ),
        // color: Colors.grey,
      ),
    );
  }

  /// the method builds a separator Widget that indicates the date(dd-MM-yyyy)
  /// for the group of messages
  /// the order of items in the list: the [0] element of the list contains
  /// the latest item and is in the bottom of the screen
  Widget _buildListSeparator(
    List<DocumentSnapshot> messages,
    int index,
  ) {
    DateTime currentItemDate = DateTime.fromMillisecondsSinceEpoch(
        messages[index]['date_time_message']);
    DateTime earlierItemDate = DateTime.fromMillisecondsSinceEpoch(
        messages[index + 1]['date_time_message']);

    if (index >= 0 && index < messages.length - 1) {
      if (currentItemDate.year != earlierItemDate.year ||
          currentItemDate.month != earlierItemDate.month ||
          currentItemDate.day != earlierItemDate.day) {
        return _buildSeparatorWidget(messages, index);
      }
    }
    return Container();
  }

  /// the method builds a separator widget
  Widget _buildSeparatorWidget(
    List<DocumentSnapshot> messages,
    int index,
  ) {
    return Align(
      alignment: Alignment.center,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.elliptical(10.0, 20.0),
          ),
        ),
        color: Colors.grey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(DateFormat.yMMMMd(localeString).format(
              DateTime.fromMillisecondsSinceEpoch(
                  messages[index]['date_time_message']))),
        ),
      ),
    );
  }
}