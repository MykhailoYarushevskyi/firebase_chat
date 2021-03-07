import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../widgets/auth/auth_form.dart';
import '../providers/auth.dart';
import '../providers/users.dart';
import '../helpers/delegate_exception.dart';

class AuthScreen extends StatefulWidget {
  static const String routeName = '/auth-screen';
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  static const String MAIN_TAG = '## AuthScreen';
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    // final double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text('Chat Authentication'),
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

  void _submitAuthForm({
    required String email,
    required String name,
    required String password,
    required bool isLogin,
    // BuildContext ctx,
  }) async {
    String? uId; // received user Id
    setState(() {
      _isLoading = true;
    });
    print('$MAIN_TAG _submitAuthForm Entrance');
    try {
      final auth = context.read<Auth>();
      if (isLogin) {
        uId = await auth.signInEmailPassword(
          userEmail: email,
          userPassword: password,
        );
        print(
            '$MAIN_TAG _submitAuthForm AFTER auth.signInEmailPassword() uId: $uId');
      } else {
        uId = await auth.signUpEmailPassword(
          userEmail: email,
          userPassword: password,
          userName: name,
        );
        print(
            '$MAIN_TAG _submitAuthForm AFTER auth.signUpEmailPassword() uId: $uId');
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
      // Instead in main.dart, in the class InitializeFirebaseApp()
      // the StreamBuilder(stream: FirebaseAuth.instance.userChanges()...
      // works as a trigger that toggles to the class "ChatScreen" because 
      // the state of the user was changed and the user is signed, 
      // or to the class "AuthScreen" if not.
      return;
    } on DelegateException catch (error) {
      print('$MAIN_TAG[E] _submitAuthForm (isLogin : $isLogin) ERROR: $error');
      var message = 'An error occurred. Please, check your credential';
      if (error != null) {
        message = error.code;
      }
      // For the ScaffoldMessenger.of(context) we need the context, where the Scaffold is.
      // Because the context of the AuthScreenState doesn't contain the Scaffold,
      // therefore we obtain it from the AuthForm widget, which is the child
      // of this AuthScreenState and it's context contains the Scaffold.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          action: SnackBarAction(
            label: 'Ok',
            onPressed: () {},
          ),
          duration: Duration(seconds: 5),
          padding: EdgeInsets.all(8.0),
          backgroundColor: Theme.of(context).errorColor,
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
        ),
      );
      //Whether this [State] object is currently in a tree.
      if (this.mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
