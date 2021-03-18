
class DelegateException {
  /// The plugin the exception is for.
  /// The value will be used to prefix the message to give more context about
  /// the exception.
  final String plugin;

  /// The long form message of the exception.
  final String? message;

  /// The optional code to accommodate the message.
  ///
  /// Allows users to identify the exception from a short code-name.
  final String code;

  /// The stack trace which provides information to the user about the call
  /// sequence that triggered an exception
  final StackTrace? stackTrace;

  DelegateException({
    this.message = '',
    this.code = 'unknown',
    this.plugin = '',
    this.stackTrace,
  });
  //  : super(plugin: '');

String toString(){
    String output = "[$plugin/$code] ${message ?? ''}";

    if (stackTrace != null) {
      output += "\n\n${stackTrace.toString()}";
    }

    return output;
}

}
