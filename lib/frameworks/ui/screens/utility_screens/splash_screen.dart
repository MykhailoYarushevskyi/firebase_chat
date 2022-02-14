import 'dart:developer';

import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    log('## SplashScreen.build()');
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Theme.of(context).primaryColor,
      body: const Center(
        child: Text('Loading ... Please wait'),
      ),
    );
  }
}
