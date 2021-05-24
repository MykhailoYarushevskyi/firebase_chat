import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:firebase_chat/common/helpers/delegate_exception.dart';
import 'package:firebase_chat/frameworks/ui/widgets/auth/auth_form.dart';
import 'package:firebase_chat/interface_adapters/presenters/providers/auth.dart';
import 'package:firebase_chat/interface_adapters/presenters/providers/users.dart';

class AuthScreen extends StatefulWidget {
  static const String routeName = '/auth-screen';
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  static const String mainTag = '## AuthScreen';
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    // final double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: const Text('Chat Authentication'),
        centerTitle: true,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          AuthForm(_submitAuthForm, _isLoading),
        ],
      ),
    );
  }

  Future<void> _submitAuthForm({
    required String email,
    required String name,
    required String password,
    required bool isLogin,
  }) async {
    String? uId; // received user's Id
    setState(() {
      _isLoading = true;
    });
    log('$mainTag _submitAuthForm Entrance');
    try {
      final auth = context.read<Auth>();
      if (isLogin) {
        uId = await auth.signInEmailPassword(
          userEmail: email,
          userPassword: password,
        );
        log(
            '$mainTag _submitAuthForm AFTER auth.signInEmailPassword() uId: $uId');
      } else {
        uId = await auth.signUpEmailPassword(
          userEmail: email,
          userPassword: password,
          userName: name,
        );
        log(
            '$mainTag _submitAuthForm AFTER auth.signUpEmailPassword() uId: $uId');
        if (uId != null) {
          await context.read<Users>().saveUserData(
                userId: uId,
                userEmail: email,
                userPassword: password,
                userName: name,
              );
        }
      }
      // Navigator.of(context).pushReplacementNamed(ChatScreen.routeName) was muted;
      // Instead in int_firebase_app.dart, in the class InitializeFirebaseApp()
      // the StreamBuilder(stream: FirebaseAuth.instance.userChanges()...
      // works as a trigger that toggles to the class "ChatScreen" because
      // the state of the user was changed and the user is signed,
      // or to the class "AuthScreen" if not.
      return;
    } on DelegateException catch (error) {
      log('$mainTag[E] _submitAuthForm (isLogin : $isLogin) ERROR: $error');
      var message = 'An error occurred. Please, check your credential';
      message = error.code;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          action: SnackBarAction(
            label: 'Ok',
            onPressed: () {},
          ),
          duration: const Duration(seconds: 5),
          padding: const EdgeInsets.all(8.0),
          backgroundColor: Theme.of(context).errorColor,
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18.0,
            ),
          ),
        ),
      );
      // Whether this [State] object is currently in a tree.
      // ignore: unnecessary_this
      if (this.mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
