import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:firebase_chat/interface_adapters/presenters/providers/auth.dart';
import 'package:firebase_chat/interface_adapters/presenters/providers/initialization_service.dart';
import 'package:firebase_chat/interface_adapters/presenters/providers/messages.dart';
import 'package:firebase_chat/interface_adapters/presenters/providers/profile_images.dart';
import 'package:firebase_chat/interface_adapters/presenters/providers/users.dart';
import 'package:firebase_chat/frameworks/ui/screens/auth_screen.dart';
import 'package:firebase_chat/frameworks/ui/screens/chat_screen.dart';
import 'package:firebase_chat/frameworks/ui/widgets/initialize_widget.dart';
import 'package:firebase_chat/app/service_locator.dart';

void main() {
  setUp();
  runApp(MyApp());}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<Auth>(create: (_) => Auth()),
          ChangeNotifierProvider<Users>(create: (_) => Users()),
          ChangeNotifierProvider<Messages>(create: (ctx) => Messages()),
          ChangeNotifierProvider<InitializationService>(
              create: (ctx) => InitializationService()),
          ChangeNotifierProvider<ProfileImages>(
              create: (ctx) => ProfileImages()),
        ],
        child: MaterialApp(
          // supportedLocales: const <Locale>[
          //   Locale('en', 'US'),
          //   Locale('uk', 'UA'),
          // ],
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
            textTheme: const TextTheme(),
          ),
          initialRoute: '/',
          routes: {
            '/': (ctx) => InitializeWidget(),
            AuthScreen.routeName: (ctx) => AuthScreen(),
            ChatScreen.routeName: (ctx) => ChatScreen(),
          },
        ));
  }
}
