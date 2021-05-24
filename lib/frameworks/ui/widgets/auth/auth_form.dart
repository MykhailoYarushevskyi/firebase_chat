import 'dart:developer';

import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  const AuthForm(
    this.submitAuthForm,
    // ignore: avoid_positional_boolean_parameters
    this.isLoading,
  );

  final void Function({
    required String email,
    required String name,
    required String password,
    required bool isLogin,
    // BuildContext ctx,
  }) submitAuthForm;
  final bool isLoading;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  static const String mainTag = '## AuthForm';
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  //TODO Avoid exiting from AuthForm without warning the user about losing the entered data
  // it will be setting in true when was any [Form] in [AuthForm]changed 
  // ignore: unused_field
  var _isChanged = false;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              onChanged: () {
                _isChanged = true;
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    key: const ValueKey('email'),
                    validator: (value) => _validateEmail(value!),
                    keyboardAppearance: Brightness.dark,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Email address'),
                    onSaved: (value) => _userEmail = value!.trim(),
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: const ValueKey('username'),
                      validator: (value) {
                        if (value!.isEmpty || value.length < 4) {
                          return 'Please enter at least 4 characters';
                        }
                        return null;
                      },
                      keyboardAppearance: Brightness.dark,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(labelText: 'User name'),
                      onSaved: (value) => _userName = value!.trim(),
                    ),
                  TextFormField(
                    key: const ValueKey('password'),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 7) {
                        return 'Password must be at least 7 characters long';
                      }
                      return null;
                    },
                    keyboardAppearance: Brightness.dark,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password'),
                    onSaved: (value) => _userPassword = value!.trim(),
                  ),
                  const SizedBox(height: 12.0),
                  if (widget.isLoading)const  CircularProgressIndicator(),
                  if (!widget.isLoading)
                    ElevatedButton(
                      onPressed: _trySubmit,
                      child: Text(
                        _isLogin ? 'Login' : 'Signup',
                        style: const TextStyle(
                            // color: Theme.of(context).primaryColor,
                            ),
                      ),
                    ),
                  if (!widget.isLoading)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                          // _formKey.currentState.reset();
                        });
                      },
                      child: Text(
                        _isLogin
                            ? 'Create a new account'
                            : 'I already have an account',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  if (_isLogin)
                    if (!widget.isLoading)
                      TextButton(
                          onPressed: () {},
                          child: const Text('Forgot the password?')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    log('$mainTag _trySubmit isValid: $isValid');
    // force the keyboard to disappear
    FocusScope.of(context).unfocus();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    log(
        '$mainTag _trySubmit save(): $_userEmail; $_userName; $_userPassword');
    widget.submitAuthForm(
      email: _userEmail,
      name: _userName,
      password: _userPassword,
      isLogin: _isLogin,
      // ctx: context,
    );
  }

  String? _validateEmail(String value) {
    // TODO add a validate with a regex
    if (value.isEmpty || !value.contains('@')) {
      return 'Please enter a valid Email address';
    }
    return null;
  }
}
