import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_chat/interface_adapters/presenters/providers/initialization_service.dart';
import 'package:firebase_chat/frameworks/ui/screens/auth_screen.dart';
import 'package:firebase_chat/frameworks/ui/screens/chat_screen.dart';
import 'package:firebase_chat/frameworks/ui/screens/utility_screens/init_error_screen.dart';
import 'package:firebase_chat/frameworks/ui/screens/utility_screens/loading_indicator.dart';

class InitializeWidget extends StatelessWidget {
  static const String routeName = '/';

  @override
  Widget build(BuildContext context) {
    //https://stackoverflow.com/questions/63492211/no-firebase-app-default-has-been-created-call-firebase-initializeapp-in
    return FutureBuilder(
        future:
            context.read<InitializationService>().initializeFirebaseApp(),
        builder: (ctx, initSnapshot) {
          if (initSnapshot.hasError) {
            const String errorTitle =
                'While initializing the FirebaseApp the error occurred:';
            return InitErrorScreen(
              title: errorTitle,
              content: initSnapshot.error as String?,
            );
          }
          return initSnapshot.connectionState == ConnectionState.waiting
              ? const LoadingIndicator(
                  message: 'Wait, please. FirebaseApp is initializing.')
              : StreamBuilder(
                  // The Stream works as a trigger that switches to the "ChatScreen" class
                  // because the user's state has changed and the user is currently signed in,
                  // or to the "AuthScreen" class if the user is not signed in (possibly logged out).
                  stream: FirebaseAuth.instance.userChanges(),
                  builder: (ctx, userSnapshot) {
                    if (userSnapshot.hasError) {
                      const String errorTitle =
                          'While listening to the User Changes the error occurred:';
                      return InitErrorScreen(
                        title: errorTitle,
                        content: userSnapshot.error as String?,
                      );
                    }
                    if (userSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const LoadingIndicator(
                          message: 'Wait, please. FirebaseAuth state loading.');
                    }
                    if (userSnapshot.hasData) {
                      return ChatScreen();
                    } else {
                      return AuthScreen();
                    }
                  },
                );
        });
  }
}
