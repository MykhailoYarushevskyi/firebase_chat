import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:firebase_chat/frameworks/ui/widgets/initialize_widget.dart';

class InitErrorScreen extends StatelessWidget {
  static const String routeName = '/error-content-screen';
  final String? title;
  final String? content;
  const InitErrorScreen({
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    String _errorTitle = 'Some error occurred!';
    String _errorContent = 'Unfortunately, the type of error does not defined';
    log('##InitErrorScreen ENTRANCE');
    if (title != null) {
      _errorTitle = title!;
    }
    if (content != null) {
      _errorContent = content!.toString();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('An Error Occured'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      margin: const EdgeInsets.symmetric(horizontal: 10.0),
                      elevation: 8.00,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          _errorTitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            color: Theme.of(context).errorColor,
                          ),
                        ),
                      ),
                    ),
                    Card(
                      margin: const EdgeInsets.symmetric(horizontal: 10.0),
                      elevation: 8.00,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          _errorContent,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.resolveWith<Color>(
                (states) => _setForegroundButtonColor(context, states),
              ),
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (states) => _setBackgroundButtonColor(context, states),
              ),
              minimumSize:
                  MaterialStateProperty.all<Size>(const Size.fromHeight(50)),
            ),
            onPressed: () => Navigator.of(context)
              ..pop()
              ..pushNamed(InitializeWidget.routeName),
            child: const Text(
              'Try again',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }

  Color _setForegroundButtonColor(
      BuildContext context, Set<MaterialState> states) {
    if (states.contains(MaterialState.pressed)) {
      return Theme.of(context).accentColor;
    }
    return Theme.of(context).errorColor;
  }

  Color _setBackgroundButtonColor(
      BuildContext context, Set<MaterialState> states) {
    if (states.contains(MaterialState.pressed)) {
      return Colors.red;
    }
    return Theme.of(context).buttonColor;
  }
}
