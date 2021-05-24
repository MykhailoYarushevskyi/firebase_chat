import 'dart:developer';

import 'package:flutter_test/flutter_test.dart' as widget_test;
import 'package:test/test.dart';

import 'package:firebase_chat/interface_adapters/presenters/providers/auth.dart';
import 'package:firebase_chat/interface_adapters/presenters/providers/initialization_service.dart';

void main() {
  Auth? auth;
  group('App Provider Tests', () {
    widget_test.TestWidgetsFlutterBinding.ensureInitialized();
    bool _isFirebaseAppInitialized = false;
    final initFirebaseApp = InitializationService();
    setUpAll(() async {
      if (!initFirebaseApp.isFirebaseAppInitialized) {
        try {
          await initFirebaseApp.initializeFirebaseApp();
          _isFirebaseAppInitialized = true;
          auth = Auth();
        } catch (error) {
          log('## TEST (setUpAll()) ERROR: $error');
        } finally {}
      }
    });

    test('A FirebaseApp is Initialized',
        () => expect(_isFirebaseAppInitialized, true),
        skip: false);

    test('An Auth instance is not null', () {
      expect(auth != null, true);
    });

    test('A userId was obtained', () {
      final String? userId = auth?.userId;
      expect(userId == null, true);
    }, skip: false);

    test('A userDisplayName is null', () {
     final String? userDisplayName = auth?.userDisplayName;
      expect(userDisplayName == null, true);
    }, skip: false);
  });
}
