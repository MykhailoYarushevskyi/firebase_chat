import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

mixin ShowDialogs {
  Future<void> showError(
    BuildContext context, {
    String title = 'Something go Wrong!',
    String error = 'Unfortunately, the type of error does not defined',
  }) async {
    if (Platform.isAndroid) {
      await showDialog(
        context: context,
        // barrierDismissible: false, // a user must tap button!
        builder: (context) => _buildErrorDialog(
          context,
          title,
          error,
        ),
      );
    } else {
      await showCupertinoDialog(
        context: context,
        builder: (context) => _buildErrorDialog(
          context,
          title,
          error,
        ),
      );
    }
  }

  Widget _buildErrorDialog(BuildContext context, String title, String error) {
    return AlertDialog(
      actions: [
        TextButton.icon(
          onPressed: () => Clipboard.setData(
            ClipboardData(text: 'TITLE: $title; ERROR: $error'),
          ),
          icon: const Icon(Icons.copy),
          label: const Text('Copy to Clipboard'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Ok'),
        )
      ],
      title: Center(
        child: Text(title),
      ),
      titleTextStyle: TextStyle(
        color: Theme.of(context).errorColor,
        fontSize: 24.0,
      ),
      content: Column(
        children: [
          const Divider(
            color: Colors.black,
            height: 2.0,
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(error),
          ),
          const Divider(
            color: Colors.black54,
            height: 1.0,
          ),
        ],
      ),
      contentTextStyle: const TextStyle(
        fontSize: 18.0,
        color: Colors.black,
      ),
      scrollable: true,
    );
  }
}
