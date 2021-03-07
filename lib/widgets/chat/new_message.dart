import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../providers/messages.dart';
import '../../providers/users.dart';
import '../../providers/auth.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  static const String MAIN_TAG = '## NewMessage';
  final textController = TextEditingController();
  String _enteredMessage = '';
  String? _currentUserId;
  String? _currentUserName;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    print('$MAIN_TAG.build() ENTRANCE');
    if (_currentUserName == null || _currentUserId == null) {
      _currentUserId = Provider.of<Auth>(context, listen: false).userId;
      _getCurrentUserName();
    }
    // Provider.of<Users>(context, listen: false)
    //     .getUserName(_currentUserId)
    //     .then((value) => _currentUserName = value);
    return Container(
      margin: EdgeInsets.only(top: 8.0),
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: textController,
              decoration: InputDecoration(labelText: 'Send a message...'),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : IconButton(
                  icon: Icon(Icons.send),
                  color: Theme.of(context).primaryColor,
                  onPressed:
                      _enteredMessage.trim().isEmpty ? null : _sendingMessage)
        ],
      ),
    );
  }

  void _sendingMessage() {
    // disappear the keyboard
    FocusScope.of(context).unfocus();
    print(
        '$MAIN_TAG _currentUserId: $_currentUserId; _currentUserName: $_currentUserName');
    context
        .read<Messages>()
        .addMessage(
          {
            'date_time_message': DateTime.now().millisecondsSinceEpoch,
            'text': _enteredMessage,
            'userId': _currentUserId != null ? _currentUserId : '',
            'userName': _currentUserName != null ? _currentUserName : '',
            'imageUrl': '',
          },
        )
        .then((_) {})
        .catchError((err) {
          // TODO showDialog
          print('$MAIN_TAG [ERROR] _sendingMessage $err');
        });
    // Because for the case of using the FirebaseFirestore SDK,
    // we may not wait for a response from the Google server,
    // even if the Internet is blocked, I placed this code here,
    // not in the [this] block, and it works immediately.
    setState(() {
      textController.clear();
      _enteredMessage = '';
    });
  }

  /// The method gets a current user's name by a current user's id from the Users
  Future<void> _getCurrentUserName() async {
    print('$MAIN_TAG._getCurrentUserName() ENTRANCE');
    setState(() {
      _isLoading = true;
    });
    try {
      String? name = await Provider.of<Users>(context, listen: false)
          .getUserName(_currentUserId);
      _currentUserName = name;
      setState(() {
        _isLoading = false;
      });
      return;
    } catch (error) {
      print('$MAIN_TAG._getUserName catchError(error): $error');
      //TODO show dialog
      setState(() {
        _isLoading = false;
      });
      return;
    }
  }
}
