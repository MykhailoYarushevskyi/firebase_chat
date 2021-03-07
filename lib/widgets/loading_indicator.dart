import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final String message;
  LoadingIndicator({this.message = ''});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 50.0),
          Container(
            height: 50,
            width: double.infinity,
            child: Text(
              message,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline6!.copyWith(
                    color: Colors.purple,
                    fontSize: 24,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
