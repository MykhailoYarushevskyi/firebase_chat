import 'dart:developer';

import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  log('## SplashScreen.build()');
    return const Scaffold(
      extendBodyBehindAppBar: true,
      body: Center(
        child: Text('Loading ... Please wait'),
      ),
    );
  }
}
