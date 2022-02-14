import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'package:firebase_chat/frameworks/ui/widgets/chat/chat_messages.dart';
import 'package:firebase_chat/frameworks/ui/widgets/chat/new_message.dart';
import 'package:firebase_chat/interface_adapters/presenters/providers/auth.dart';
import 'package:firebase_chat/interface_adapters/presenters/providers/notifications.dart';

class ChatScreen extends StatefulWidget {
  static const String routeName = '/chat-screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  static const String mainTag = '## ChatScreen';
  final localeString = 'uk';

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    // Initializing of Firebase Cloud Messages
    context.read<Notifications>().setFCMPermission();

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Multiuser Chat'),
        centerTitle: true,
        actions: const [AppBarDropDownMenu()],
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatMessages(),
          ),
          NewMessage(),
        ],
      ),
    );
  }
}

class AppBarDropDownMenu extends StatelessWidget {
  const AppBarDropDownMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    return DropdownButton(
      underline: const SizedBox(),
      icon: const Icon(Icons.more_vert),
      items: [
        DropdownMenuItem(
          value: 'settings',
          child: Row(
            children: const [
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
        DropdownMenuItem(
          value: 'logout',
          child: Row(
            children: const [
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
      ],
      onChanged: (dynamic value) {
        if (value == 'logout') {
          auth.signOut();
        } else if (value == 'settings') {
          log('##AppBarMenu settings menu <Logout> item pressed');
        }
      },
    );
  }
}
