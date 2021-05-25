import 'dart:developer';

import 'package:firebase_chat/interface_adapters/presenters/presenter_models/presenter_message_model.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:firebase_chat/common/helpers/delegate_exception.dart';
import 'package:firebase_chat/frameworks/ui/widgets/utility/show_dialogs.dart';
import 'package:firebase_chat/interface_adapters/presenters/providers/auth.dart';
import 'package:firebase_chat/interface_adapters/presenters/providers/messages.dart';
import 'package:firebase_chat/interface_adapters/presenters/providers/users.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> with ShowDialogs {
  static const String mainTag = '## NewMessage';
  final textController = TextEditingController();
  String _enteredMessage = '';
  String? _currentUserId;
  String? _currentUserName;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    log('$mainTag.build() ENTRANCE');

    if (_currentUserName == null || _currentUserId == null) {
      _currentUserId = Provider.of<Auth>(context, listen: false).userId;
      _getCurrentUserName();
    }
    return Container(
      margin: const EdgeInsets.only(top: 8.0),
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: textController,
              decoration: const InputDecoration(labelText: 'Send a message...'),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
          if (!_isLoading)
            Container(
              padding: const EdgeInsets.all(0.00),
              margin: EdgeInsets.zero,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.75),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                  icon: const Icon(
                    Icons.send,
                  ),
                  color: Colors.white,
                  onPressed:
                      _enteredMessage.trim().isEmpty ? null : _sendingMessage),
            )
        ],
      ),
    );
  }

  void _sendingMessage() {
    // disappear the keyboard
    FocusScope.of(context).unfocus();
    log('$mainTag _currentUserId: $_currentUserId; _currentUserName: $_currentUserName');
    context
        .read<Messages>()
        .addMessage(PresenterMessageModel(
            messageId: '',
            userId: _currentUserId ?? '',
            userName: _currentUserName ?? '',
            dateTimeMessage: DateTime.now().millisecondsSinceEpoch,
            imageUrl: ' ',
            textMessage: _enteredMessage))
        .then((_) {})
        .catchError((error) {
      _showCommonError(
        'While sending the message an Error occurred!',
        error as String,
      );
      log('$mainTag [ERROR] _sendingMessage $error');
    });
    // Because for the case of using the FirebaseFirestore SDK,
    // we may not wait for a response from the Google server,
    // even if the Internet is blocked, I placed this code here,
    // not in the [.then((_) {})] block, and it works immediately.
    setState(() {
      textController.clear();
      _enteredMessage = '';
    });
  }

  /// The method gets a current user's name by a current user's id from the Users
  Future<void> _getCurrentUserName() async {
    log('$mainTag._getCurrentUserName() ENTRANCE');
    setState(() {
      _isLoading = true;
    });
    try {
      final String? name = await Provider.of<Users>(context, listen: false)
          .getUserName(_currentUserId);
      _currentUserName = name;
      setState(() {
        _isLoading = false;
      });
      return;
    } on DelegateException catch (error) {
      _showDelegateExceptionError(
        'While getting the user name an Error occurred!',
        error,
      );
      return;
    } catch (error) {
      _showCommonError(
        'While getting the user name an Error occurred!',
        error as String,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showDelegateExceptionError(
    String errorTitle,
    DelegateException error,
  ) {
    showError(
      context,
      title: errorTitle,
      error: error.code,
    );
  }

  void _showCommonError(String errorTitle, String error) {
    showError(
      context,
      title: errorTitle,
      error: error,
    );
  }
}
