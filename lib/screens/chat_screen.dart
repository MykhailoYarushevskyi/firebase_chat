import 'package:flutter/material.dart';

import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../widgets/chat/chat_messages.dart';
import '../widgets/chat/new_message.dart';

class ChatScreen extends StatefulWidget {
  static const String routeName = '/chat-screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  static const String MAIN_TAG = '## ChatScreen';
  final localeString = 'uk';
  double _deviceHeight;
  double _deviceWidth;

  @override
  void initState() {
    super.initState();
    //package:intl/date_symbol_data_local.dart
    initializeDateFormatting();
    // In our case we initialize the default Firebase App in main().
    // As a variant, we could be calling  initializeApp() here,
    // and in the build() method, before StreamBuilder<>()
    // use !messagesInstance.isFirebaseAppInitialized
    //          ? CircularProgressIndicator()
    //          :
    //
/*     context.read<Messages>().initializeFirebaseApp().whenComplete(() {
      setState(() {
      });
    }); */
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);

    // initFirebase();
    print(
        '$MAIN_TAG _deviceHeight: $_deviceHeight; _deviceWidth: $_deviceWidth');
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        centerTitle: true,
        actions: [
          DropdownButton(
              icon: Icon(Icons.more_vert),
              items: [
                DropdownMenuItem(
                  child: Container(
                    child: Row(
                      children: [
                        Icon(
                          Icons.exit_to_app,
                          color: Theme.of(context).primaryIconTheme.color,
                        ),
                        SizedBox(width: 6.0),
                        Text(
                          'Sign Out',
                        ),
                      ],
                    ),
                  ),
                  value: 'signOut',
                ),
              ],
              onChanged: (value) {
                if (value == 'signOut') {
                  //user logout
                  auth.signOut();
                }
              })
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: ChatMessages(),
            ),
            NewMessage(),
          ],
        ),
      ),
    );
  }
}
