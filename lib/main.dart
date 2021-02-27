import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'widgets/loading_indicator.dart';
import 'screens/chat_screen.dart';
import 'screens/auth_screen.dart';
import 'providers/messages.dart';
import 'providers/auth.dart';
import 'providers/users.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<Auth>(create: (_) => Auth()),
          ChangeNotifierProvider<Users>(create: (_) => Users()),
          ChangeNotifierProvider<Messages>(create: (ctx) => Messages()),
          /* ChangeNotifierProxyProvider<Auth, Messages>(
          create: (_) => Messages(),
          update: (_, auth, messages) => messages
            ..update(auth...),
          child: ...
        ); */
        ],
        //https://stackoverflow.com/questions/63492211/no-firebase-app-default-has-been-created-call-firebase-initializeapp-in
        child: MaterialApp(
          locale: null,
          title: 'Firebase Chat',
          theme: ThemeData(
            primaryColor: Colors.pink,
            backgroundColor: Colors.pink,
            accentColor: Colors.deepPurple,
            accentColorBrightness: Brightness.dark,
            buttonTheme: ButtonTheme.of(context).copyWith(
              buttonColor: Colors.pink,
              textTheme: ButtonTextTheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            textTheme: TextTheme(),
          ),
          initialRoute: '/',
          routes: {
            '/': (ctx) => InitializeFirebaseApp(),
            AuthScreen.routeName: (ctx) => AuthScreen(),
            ChatScreen.routeName: (ctx) => ChatScreen(),
          },
        ));
  }
}

class InitializeFirebaseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: context.read<Messages>().initializeFirebaseApp(),
        // future: Provider.of<Messages>(context, listen: false).initializeFirebaseApp(),
        builder: (ctx, initSnapshot) {
          if (initSnapshot.hasError) {
            //TODO showDialog about error (may be, return appropriate page)
            print('## MyApp initSnapshot.hasError ${initSnapshot.error}');
          }
          return initSnapshot.connectionState == ConnectionState.waiting
              ? LoadingIndicator(
                  message: 'Wait, please. FirebaseApp is initializing.')
              : StreamBuilder(
                  // The stream works as a trigger that toggles to the class "ChatScreen" because
                  // the state of the user was changed and the user is signed,
                  // or to the class "AuthScreen" if not.
                  stream: FirebaseAuth.instance.userChanges(),
                  builder: (ctx, userSnapshot) {
                    if (userSnapshot.hasError) {
                      //TODO showDialog about error (may be, return appropriate page)
                      print(
                          '## MyApp userSnapshot.hasError ${userSnapshot.error}');
                    }
                    if (userSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return LoadingIndicator(
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
