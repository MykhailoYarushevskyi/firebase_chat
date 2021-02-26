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
  var _enteredMessage = '';
  String _userId;
  String _userName;

  @override
  Widget build(BuildContext context) {
    _userId = Provider.of<Auth>(context, listen: false).userId;
    Provider.of<Users>(context, listen: false)
        .getUserName(_userId)
        .then((value) => _userName = value);
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
          IconButton(
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
    print('$MAIN_TAG _userId: $_userId; _userName: $_userName');
    context.read<Messages>().addMessage(
      {
        'date_time_message': DateTime.now().millisecondsSinceEpoch,
        'text': _enteredMessage,
        'userId': _userId != null ? _userId : '',
        'userName': _userName != null ? _userName : '',
        'imageUrl': '',
      },
    ).then((_) {
      setState(() {
        textController.clear();
        _enteredMessage = '';
      });
    }).catchError((err) {
      // TODO showDialog
      print('$MAIN_TAG [ERROR] _sendingMessage $err');
    });
  }
}
