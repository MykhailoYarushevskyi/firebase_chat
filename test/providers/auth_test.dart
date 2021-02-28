import 'package:firebase_chat/providers/auth.dart';
import 'package:firebase_chat/providers/initialization_firebase_app.dart';
import 'package:test/test.dart';

void main() {
  group('App Provider Tests', () {
    var auth = Auth();
    InitializationFirebaseApp().initializeFirebaseApp().then((_) {
      test('A userId was obtained', () {
        var userId = auth.userId;
        expect(userId != null, true);
      });
      test('A userDisplayName is null', () {
        var userDisplayName = auth.userDisplayName;
        expect(userDisplayName == null, true);
      });

    });
  });
}
