import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';

class InitializationService with ChangeNotifier {
  static const String mainTag = '## InitializeFirebaseApp';
  var _isFirebaseAppInitialized = false;

  bool get isFirebaseAppInitialized => _isFirebaseAppInitialized;

  Future<void> initializeFirebaseApp() async {
    log('$mainTag initializeFirebaseApp() ENTRANCE. _isFirebaseAppInitialized:$_isFirebaseAppInitialized');
    if (_isFirebaseAppInitialized) {
      return;
    } else {
      try {
        await Firebase.initializeApp();
        _isFirebaseAppInitialized = true;
        log('$mainTag initializeFirebaseApp() EXIT. _isFirebaseAppInitialized:$_isFirebaseAppInitialized');
        return;
      } catch (error) {
        log('$mainTag initializeFirebaseApp() catch(error). error: $error');
        rethrow;
      }
    }
  }
}
