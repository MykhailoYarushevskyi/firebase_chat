import 'dart:developer';

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

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    // Initializing of Firebase Cloud Messages
    // setFCMPermission();

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
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);

    // initFirebase();
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
                          Icons.settings,
                          color: Colors.black,
                        ),
                        SizedBox(width: 6.0),
                        Text(
                          'Settings',
                        ),
                      ],
                    ),
                  ),
                  value: 'settings',
                ),
                DropdownMenuItem(
                  child: Container(
                    child: Row(
                      children: [
                        Icon(
                          Icons.exit_to_app,
                          color: Colors.black,
                        ),
                        SizedBox(width: 6.0),
                        Text(
                          'Logout',
                        ),
                      ],
                    ),
                  ),
                  value: 'logout',
                ),
              ],
              onChanged: (dynamic value) {
                if (value == 'logout') {
                  auth.signOut();
                } else if (value == 'settings') {
                  log('$MAIN_TAG settings menu item pressed');
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
