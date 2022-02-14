import 'package:flutter/material.dart';
import 'package:focused_menu/modals.dart';

import 'package:intl/intl.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:provider/provider.dart';

import 'package:firebase_chat/interface_adapters/presenters/presenter_models/presenter_message_model.dart';
import 'package:firebase_chat/interface_adapters/presenters/providers/auth.dart';
import 'package:firebase_chat/interface_adapters/presenters/providers/messages.dart';

late double _deviceWidth;
late Messages _messagesInstance;

class ChatMessages extends StatelessWidget {
  static const String mainTag = '## ChatMessages';
  final localeString = 'uk';

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    _messagesInstance = Provider.of<Messages>(context, listen: false);
    final currentUserId = Provider.of<Auth>(context, listen: false).userId;
    List<PresenterMessageModel>? _messages;
    return StreamBuilder<List<PresenterMessageModel>>(
        stream: _messagesInstance.getMessages(),
        builder: (context, streamSnapshot) {
          if (streamSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          _messages = getMessages(streamSnapshot);
          bool isMessagesEmpty = false;
          if (_messages != null) {
            isMessagesEmpty = _messages!.isEmpty;
          }
          return !streamSnapshot.hasData || isMessagesEmpty || _messages == null
              // ? const SizedBox(width: 0.0, height: 0.0)
              ? Center(
                  child: Text(
                    'There are no Messages yet!',
                    style: TextStyle(
                        fontSize: 24, color: Theme.of(context).primaryColor),
                  ),
                )
              : ListView.separated(
                  reverse: true,
                  itemCount: _messages!.length,
                  separatorBuilder: (ctx, index) =>
                      _buildListSeparator(_messages!, index),
                  itemBuilder: (ctx, index) {
                    final messageUserId = _messages![index].userId;
                    final bool isMyMessage = messageUserId == currentUserId;
                    return GestureDetector(
                      onLongPress: () {
                        if (isMyMessage) {
                          _messagesInstance
                              .deleteMessage(_messages![index].messageId);
                        }
                      },
                      child: _buildListItem(
                          _messages!, index, isMyMessage, _deviceWidth),
                    );
                  });
        });
  }

  /// the method returns the list of messages [DocumentSnapshot].
  List<PresenterMessageModel>? getMessages(
    AsyncSnapshot<List<PresenterMessageModel>> streamSnapshot,
  ) {
    List<PresenterMessageModel>? messages;
    if (streamSnapshot.hasData) {
      messages = streamSnapshot.data;
    }
    return messages;
  }

  /// builds a Widget that contains the user's messages
  Widget _buildListItem(
    List<PresenterMessageModel> messages,
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

  /// returns the list item's widget
  Widget _buildItemWidget(
    List<PresenterMessageModel> messages,
    int index,
    bool isMyMessage,
    double deviceWidth,
  ) {
    // current message and previous message will be separated
    final bool willBeSeparatedCurrentMessage =
        _willSeparatedMessages(messages, index);
    bool isCurrentUserDifferentWithPreviousUser = true;
    // will be indent between current and previous messages
    bool indentNormal = false;
    if (index >= 0 && index < messages.length - 1) {
      final String currentUserId = messages[index].userId;
      final String earlierUserId = messages[index + 1].userId;
      isCurrentUserDifferentWithPreviousUser =
          currentUserId.compareTo(earlierUserId) != 0;
      if (willBeSeparatedCurrentMessage ||
          isCurrentUserDifferentWithPreviousUser) {
        indentNormal = true;
      }
    }
    return _buildItemWidgetWithComtextMenu(
      child: Align(
        alignment: isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(maxWidth: deviceWidth * 0.6),
          margin: EdgeInsets.only(
            left: 8.0,
            right: 8.0,
            top: indentNormal ? 10.0 : 2.0,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 10.0,
          ),
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: isMyMessage
                ? BorderRadius.only(
                    bottomLeft: const Radius.circular(18.0),
                    bottomRight: const Radius.circular(18.0),
                    topLeft: const Radius.circular(18.0),
                    topRight: isCurrentUserDifferentWithPreviousUser
                        ? Radius.zero
                        : const Radius.circular(18.0),
                  )
                : BorderRadius.only(
                    bottomLeft: const Radius.circular(18.0),
                    bottomRight: const Radius.circular(18.0),
                    topLeft: isCurrentUserDifferentWithPreviousUser
                        ? Radius.zero
                        : const Radius.circular(18.0),
                    topRight: const Radius.circular(18.0),
                  ),
            color: isMyMessage ? Colors.lightBlue[50] : Colors.grey[200],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isMyMessage &&
                  (isCurrentUserDifferentWithPreviousUser ||
                      willBeSeparatedCurrentMessage))
                Text(
                  messages[index].userName,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              Text(messages[index].textMessage.toString()),
            ],
          ),
        ),
      ),
    );
  }

  /// builds the message widget with context menu
  /// [child] message widget
  Widget _buildItemWidgetWithComtextMenu({
    required Widget child,
  }) {
    return FocusedMenuHolder(
      menuWidth: _deviceWidth * 0.40,
      blurSize: 5.0,
      menuItemExtent: 45,
      menuBoxDecoration: const BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      duration: const Duration(milliseconds: 100),
      animateMenuItems: true,
      blurBackgroundColor: Colors.black54,
      // openWithTap: false, // Open Focused-Menu on Tap rather than Long Press
      menuOffset: 10.0, // Offset value to show menuItem from the selected item
      bottomOffsetHeight:
          80.0, // Offset height to consider, for showing the menu item ( for example bottom navigation bar), so that the popup menu will be shown on top of selected item.
      menuItems: <FocusedMenuItem>[
        // Add Each FocusedMenuItem  for Menu Options
        FocusedMenuItem(
            title: const Text("Open"),
            trailingIcon: const Icon(Icons.open_in_new),
            onPressed: () {
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => PlayGround()));
            }),
        FocusedMenuItem(
            title: const Text("Share"),
            trailingIcon: const Icon(Icons.share),
            onPressed: () {}),
        FocusedMenuItem(
            title: const Text("Modify"),
            trailingIcon: const Icon(Icons.edit),
            onPressed: () {}),
        FocusedMenuItem(
            title:
                const Text("Delete", style: TextStyle(color: Colors.redAccent)),
            trailingIcon: const Icon(
              Icons.delete,
              color: Colors.redAccent,
            ),
            onPressed: () {}),
      ],
      onPressed: () {},
      child: child,
    );
  }

  bool _willSeparatedMessages(List<PresenterMessageModel> messages, int index) {
    if (index >= 0 && index < messages.length - 1) {
      final DateTime currentItemDate =
          DateTime.fromMillisecondsSinceEpoch(messages[index].dateTimeMessage);
      final DateTime earlierItemDate = DateTime.fromMillisecondsSinceEpoch(
          messages[index + 1].dateTimeMessage);
      return _isYearMonthDayNotTheSame(
        firstDate: currentItemDate,
        secondDate: earlierItemDate,
      );
    }
    return false;
  }

  /// the method builds a separator Widget that indicates the date(dd-MM-yyyy)
  /// for the group of messages
  /// the order of items in the list: the [0] element of the list contains
  /// the latest item and is in the bottom of the screen
  Widget _buildListSeparator(
    List<PresenterMessageModel> messages,
    int index,
  ) {
    final DateTime currentItemDate =
        DateTime.fromMillisecondsSinceEpoch(messages[index].dateTimeMessage);
    final DateTime earlierItemDate = DateTime.fromMillisecondsSinceEpoch(
        messages[index + 1].dateTimeMessage);
    final mustBeSeparated = _isYearMonthDayNotTheSame(
      firstDate: currentItemDate,
      secondDate: earlierItemDate,
    );
    if (index >= 0 && index < messages.length - 1 && mustBeSeparated) {
      return _buildSeparatorWidget(messages, index);
    }
    return Container();
  }

  /// the method builds a separator widget
  Widget _buildSeparatorWidget(
    List<PresenterMessageModel> messages,
    int index,
  ) {
    return Align(
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.elliptical(10.0, 20.0),
          ),
        ),
        color: Colors.grey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(DateFormat.yMMMMd(localeString).format(
              DateTime.fromMillisecondsSinceEpoch(
                  messages[index].dateTimeMessage))),
        ),
      ),
    );
  }

  bool _isYearMonthDayNotTheSame({
    required DateTime firstDate,
    required DateTime secondDate,
  }) {
    if (firstDate.year != secondDate.year ||
        firstDate.month != secondDate.month ||
        firstDate.day != secondDate.day) {
      return true;
    }
    return false;
  }
}
