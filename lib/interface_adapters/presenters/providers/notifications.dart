import 'dart:developer';

import 'package:flutter/foundation.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

class Notifications with ChangeNotifier {
  FirebaseMessaging get _fcmInstance {
    return FirebaseMessaging.instance;
  }

  Future<void> setFCMPermission() async {
    log('## Notifications setFCMPermission() _fcmInstance: $_fcmInstance');
    final NotificationSettings notificationSettings =
        await _fcmInstance.requestPermission();
    log('## Notifications setFCMPermission() notificationSettings: $notificationSettings');
    //(instead of onMessage) 
    FirebaseMessaging.onMessage
        .listen((msg) => log('## Notifications onMessage: message: $msg'));
    //(instead of onLaunch and onResume).
    FirebaseMessaging.onMessageOpenedApp
    .listen((msg) => log('## Notifications onMessageOpenedApp: message: $msg'));

    // final String? token = await _getToken();
    // log('## Notifications setFCMPermission() token: $token');
  }

  Future<String?> _getToken() async {
    final token = await _fcmInstance.getToken();
    return token;
  }
}
