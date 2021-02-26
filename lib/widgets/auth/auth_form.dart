import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  AuthForm(
    this.submitAuthForm,
    this.isLoading,
  );

  final void Function({
    String email,
    String name,
    String password,
    bool isLogin,
    BuildContext ctx,
  }) submitAuthForm;
  final bool isLoading;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  static const String MAIN_TAG = '## AuthForm';
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  // it will be setting in true when was any [Form] in [AuthForm]changed
  // var _isChanged = false;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              onChanged: () {
                // _isChanged = true;
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    key: ValueKey('email'),
                    validator: (value) => _validateEmail(value),
                    keyboardAppearance: Brightness.dark,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: 'Email address'),
                    onSaved: (value) => _userEmail = value.trim(),
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('username'),
                      validator: (value) {
                        if (value.isEmpty || value.length < 4) {
                          return 'Please enter at least 4 characters';
                        }
                        return null;
                      },
                      keyboardAppearance: Brightness.dark,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(labelText: 'User name'),
                      onSaved: (value) => _userName = value.trim(),
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    validator: (value) {
                      if (value.isEmpty || value.length < 7) {
                        return 'Password must be at least 7 characters long';
                      }
                      return null;
                    },
                    keyboardAppearance: Brightness.dark,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Password'),
                    onSaved: (value) => _userPassword = value.trim(),
                  ),
                  SizedBox(height: 12.0),
                  if (widget.isLoading) CircularProgressIndicator(),
                  if (!widget.isLoading)
                    RaisedButton(
                      child: Text(
                        _isLogin ? 'Login' : 'Signup',
                        style: TextStyle(
                            // color: Theme.of(context).primaryColor,
                            ),
                      ),
                      onPressed: _trySubmit,
                    ),
                  if (!widget.isLoading)
                    FlatButton(
                      child: Text(
                        _isLogin
                            ? 'Create a new account'
                            : 'I already have an account',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                          // _formKey.currentState.reset();
                        });
                      },
                    ),
                  if (_isLogin)
                    if (!widget.isLoading)
                      FlatButton(
                          onPressed: () {},
                          child: Text('Forgot the password?')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    print('$MAIN_TAG _trySubmit isValid: $isValid');
    // force the keyboard to disappear
    FocusScope.of(context).unfocus();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();
    print(
        '$MAIN_TAG _trySubmit save(): $_userEmail; $_userName; $_userPassword');
    widget.submitAuthForm(
      email: _userEmail,
      name: _userName,
      password: _userPassword,
      isLogin: _isLogin,
      ctx: context,
    );
  }

  String _validateEmail(String value) {
    // TODO add a validate with a regex
    if (value.isEmpty || !value.contains('@')) {
      return 'Please enter a valid Email address';
    }
    return null;
  }
}
