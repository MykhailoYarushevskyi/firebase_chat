import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';

class InitializationFirebaseApp with ChangeNotifier {
  static const String MAIN_TAG = '## InitializeFirebaseApp';
  var _isFirebaseAppInitialized = false;

  bool get isFirebaseAppInitialized => _isFirebaseAppInitialized;

  Future<void> initializeFirebaseApp() async {
    print('$MAIN_TAG initializeFirebaseApp() Entrance');
    if (_isFirebaseAppInitialized) {
        print('$MAIN_TAG FirebaseApp has already been initialized!');
      return;
    } else {
      return Firebase.initializeApp().then((value) {
        _isFirebaseAppInitialized = true;
        print('$MAIN_TAG Firebase.initializeApp().then()');
      }).catchError((error) => throw error);
    }
  }
}
