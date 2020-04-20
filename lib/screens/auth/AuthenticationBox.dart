import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/common/snackbar.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/rest/http_exception.dart';

enum AuthenticationMode { SignIn, SignUp }

class AuthenticationBox extends StatefulWidget {
  @override
  _AuthenticationBoxState createState() => _AuthenticationBoxState();
}

class _AuthenticationBoxState extends State<AuthenticationBox> {
  final _passwordNode = FocusNode();
  bool _passwordVisible = false;
  final _form = GlobalKey<FormState>();
  final _map = Map<String, String>();
  var _mode = AuthenticationMode.SignIn;
  bool _requesting = false;
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordNode.dispose();
    super.dispose();
  }

  static String validateEmail(String email) {
    Pattern emailRegex =
        r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?";
    final regex = RegExp(emailRegex);
    if (regex.hasMatch(email)) return null;
    return "Email ID is not valid";
  }

  static String validatePassword(String password) {
    if (password.length >= 6) return null;

    return "Password must be at least 6 characters long";
  }

  void _saveForm() async {
    if (_form.currentState.validate()) {
      _form.currentState.save();
      setState(() {
        _requesting = true;
      });
      final auth = Provider.of<Auth>(context, listen: false);
      try {
        if (_mode == AuthenticationMode.SignIn) {
          await auth.login(_map['email'], _map['password']);
        } else if (_mode == AuthenticationMode.SignUp) {
          await auth.signUp(_map['email'], _map['password']);
        }
      } on AuthenticationException catch (e) {
        MySnackBar(e.message).show(context);
      } catch (e) {
        MySnackBar('Some unknown error occured! Please try again later')
            .show(context);
      } finally {
        setState(() {
          _requesting = false;
        });
      }
    }
  }

  void _toggleMode() {
    if (_mode == AuthenticationMode.SignIn)
      _mode = AuthenticationMode.SignUp;
    else
      _mode = AuthenticationMode.SignIn;
  }

  bool _isSignIn() {
    return _mode == AuthenticationMode.SignIn;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 50),
        child: Container(
          padding: EdgeInsets.all(30),
          child: Form(
            key: _form,
            child: SingleChildScrollView(
              child: Column(children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                      hintText: 'Email ID', icon: Icon(Icons.email)),
                  validator: (value) => validateEmail(value),
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_passwordNode),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  onSaved: (value) => _map['email'] = value,
                ),
                TextFormField(
                  focusNode: _passwordNode,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    icon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      onPressed: () =>
                          setState(() => _passwordVisible = !_passwordVisible),
                      icon: Icon(
                        // Based on passwordVisible state choose the icon
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                  ),
                  validator: (value) => validatePassword(value),
                  keyboardType: TextInputType.text,
                  obscureText: !_passwordVisible,
                  onSaved: (value) => _map['password'] = value,
                ),
                _isSignIn()
                    ? SizedBox(
                        width: 0,
                        height: 0,
                      )
                    : TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Confirm password',
                          icon: Icon(Icons.lock),
                        ),
                        validator: (value) {
                          return value == _passwordController.text
                              ? null
                              : 'Passwords does not match';
                        },
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).requestFocus(_passwordNode),
                        keyboardType: TextInputType.text,
                        obscureText: !_passwordVisible,
                      ),
                SizedBox(
                  height: 20,
                ),
                _requesting
                    ? Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: CircularProgressIndicator(),
                      )
                    : RaisedButton(
                        color: Theme.of(context).primaryColor,
                        onPressed: _saveForm,
                        child: Text(
                          _isSignIn() ? 'Login' : 'Sign Up',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                FlatButton(
                  onPressed:
                      _requesting ? null : () => setState(() => _toggleMode()),
                  child: Text(
                    _isSignIn() ? 'Sign Up instead' : 'Login instead',
                    style: TextStyle(color: Colors.blue),
                  ),
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
