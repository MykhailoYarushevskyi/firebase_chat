import 'package:flutter/foundation.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

class Notifications with ChangeNotifier {
  
  FirebaseMessaging get getFCMInstance {
    return FirebaseMessaging.instance;
  }

  void setFCMPermission() {
    getFCMInstance.requestPermission();
  }
}
