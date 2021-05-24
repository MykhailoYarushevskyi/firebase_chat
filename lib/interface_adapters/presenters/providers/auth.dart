import 'dart:developer';

import 'package:flutter/cupertino.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_chat/common/helpers/delegate_exception.dart';

class Auth with ChangeNotifier {
  static const String mainTag = '## Auth';
  final firebaseAuthInstance = FirebaseAuth.instance;

  String? get userId {
    final currentUser = firebaseAuthInstance.currentUser;
    if (currentUser == null) {
      return null;
    } else {
      return currentUser.uid;
    }
  }

  String? get userDisplayName {
    final currentUser = firebaseAuthInstance.currentUser;
    if (currentUser == null) {
      return null;
    } else {
      log('$mainTag get userName displayName: ${currentUser.displayName}');
      return currentUser.displayName;
    }
  }

  /// Attempts to sign in a user with the given email address and password.
  /// If successful, it also signs the user in into the app and updates
  /// any [authStateChanges], [idTokenChanges] or [userChanges]
  /// stream listeners.Important: You must enable Email & Password accounts
  /// in the Auth section of the Firebase console before being able to use them.
  Future<String?> signInEmailPassword({
    required String userEmail,
    required String userPassword,
  }) async {
    log('$mainTag signInEmailPassword Entrance');
    try {
      final userCredential =
          await firebaseAuthInstance.signInWithEmailAndPassword(
        email: userEmail,
        password: userPassword,
      );
      log('$mainTag signInEmailPassword: $userCredential');
      if (userCredential.user != null) {
        return userCredential.user!.uid;
      } else {
        return null;
      }
    } on FirebaseException catch (error) {
      log('$mainTag signInEmailPassword() error.code: ${error.code}');
      throw DelegateException(
        message: error.message,
        plugin: error.plugin,
        code: error.code,
        stackTrace: error.stackTrace,
      );
    } catch (error) {
      log('$mainTag signInEmailPassword() error: $error');
      rethrow;
/*
  Attempts to sign in a user with the given email address and password.
If successful, it also signs the user in into the app and updates any 
[authStateChanges], [idTokenChanges] or [userChanges] stream listeners.
Important: You must enable Email & Password accounts in the Auth section 
of the Firebase console before being able to use them.
A [FirebaseAuthException] maybe thrown with the following error code:
! invalid-email:
Thrown if the email address is not valid.
! user-disabled:
Thrown if the user corresponding to the given email has been disabled.
! user-not-found:
Thrown if there is no user corresponding to the given email.
! wrong-password:
Thrown if the password is invalid for the given email, 
or the account corresponding to the email does not have a password set. 
*/
    }
  }

  /// method tries to create a new user account
  /// with the given email address [userEmail] and password [userPassword].
  Future<String?> signUpEmailPassword({
    required String userEmail,
    required String userPassword,
    String? userName,
  }) async {
    log('$mainTag signUpEmailPassword Entrance');
    try {
      final userCredential =
          await firebaseAuthInstance.createUserWithEmailAndPassword(
        email: userEmail,
        password: userPassword,
      );
      log('$mainTag signUpEmailPassword: $userCredential');
      if (userCredential.user != null) {
        return userCredential.user!.uid;
      } else {
        return null;
      }
    } on FirebaseException catch (error) {
      log('$mainTag signInEmailPassword() error.code: ${error.code}');
      throw DelegateException(
        message: error.message,
        plugin: error.plugin,
        code: error.code,
        stackTrace: error.stackTrace,
      );
    } catch (error) {
      log('$mainTag signInEmailPassword() error: $error');
      rethrow;
/* 
A [FirebaseAuthException] maybe thrown with the following error code:
! email-already-in-use:
Thrown if there already exists an account with the given email address.
! invalid-email:
Thrown if the email address is not valid.
! operation-not-allowed:
Thrown if email/password accounts are not enabled.
Enable email/password accounts in the Firebase Console, under the Auth tab.
! weak-password:
Thrown if the password is not strong enough. 
       */
    }
  }

  /// Signs out the current user If successful, it also updates any
  /// [authStateChanges], [idTokenChanges] or [userChanges]
  /// stream listeners.
  void signOut() {
    firebaseAuthInstance.signOut();
  }
}
