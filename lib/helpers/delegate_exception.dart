import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';

class DelegateException extends FirebaseException {
  /// The plugin the exception is for.
  ///
  /// The value will be used to prefix the message to give more context about
  /// the exception.
  final String plugin;

  /// The long form message of the exception.
  final String message;

  /// The optional code to accommodate the message.
  ///
  /// Allows users to identify the exception from a short code-name.
  final String code;

  /// The stack trace which provides information to the user about the call
  /// sequence that triggered an exception
  final StackTrace stackTrace;

  DelegateException({
    @required this.message,
    this.code,
    @required this.plugin,
    this.stackTrace,
  });

String toString(){
    String output = "[$plugin/$code] $message";

    if (stackTrace != null) {
      output += "\n\n${stackTrace.toString()}";
    }

    return output;
}

}
