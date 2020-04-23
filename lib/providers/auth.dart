import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/providers/rest/SECRETS.dart';
import 'package:shop_app/providers/rest/http_exception.dart';

class FieldKeys {
  static const expire = "login_expiry";
  static const userId = "login_userId";
  static const email = "login_email";
  static const token = "login_token";
}

class Auth with ChangeNotifier {
  static const apiKey = FIREBASE_API_KEY;
  String _token;
  DateTime _expire;
  String _userId;
  String _email;
  Timer _authTimer;

  String get userId => _userId;

  Auth() {
    _loadCreds();
  }

  Future<void> _saveCreds() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(FieldKeys.email, _email);
    prefs.setString(FieldKeys.userId, _userId);
    prefs.setString(FieldKeys.token, _token);
    prefs.setInt(FieldKeys.expire, _expire.millisecondsSinceEpoch);
  }

  Future<void> _loadCreds() async {
    final prefs = await SharedPreferences.getInstance();
    _email = prefs.getString(FieldKeys.email);
    _userId = prefs.getString(FieldKeys.userId);
    _token = prefs.getString(FieldKeys.token);
    final time = prefs.getInt(FieldKeys.expire);
    if (time != null) _expire = DateTime.fromMillisecondsSinceEpoch(time);
    print(loggedIn);
    print('$_email: ${_token}, $_userId');
    if (loggedIn) {
      print('logged In');
      notifyListeners();
    }
  }

  Future<void> _authenticate(
      String email, String password, String endpoint) async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:$endpoint?key=$apiKey";
    final res = await http.post(url,
        body: json.encode(
            {'email': email, 'password': password, 'returnSecureToken': true}));
    final jsonResp = json.decode(res.body);

    if (res.statusCode == 200) {
      _email = jsonResp['email'];
      _userId = jsonResp['localId'];
      _token = jsonResp['idToken'];
      _expire = DateTime.now()
          .add(Duration(seconds: int.parse(jsonResp['expiresIn'])));
      _saveCreds();
      notifyListeners();
    } else {
      if (jsonResp['error'] != null) {
        var message = jsonResp['error']['message'];
        if (message == "EMAIL_NOT_FOUND") {
          message = "Email Id not found! Please Sign up first.";
        } else if (message == "INVALID_PASSWORD") {
          message = "Password is invalid";
        } else if (message == "USER_DISABLED") {
          message = "This user is disabled! Please contact administrator";
        } else if (message == "EMAIL_EXISTS") {
          message = "This email already exists! Do you mean to login?";
        } else if (message == "OPERATION_NOT_ALLOWED") {
          message = "This operation is not allowed.";
        } else if (message == "TOO_MANY_ATTEMPTS_TRY_LATER") {
          message = "Too many attempts! Please try again later";
        } else {
          throw http.ClientException(res.body);
        }
        throw AuthenticationException(message);
      }
    }
    autoLogout();
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, "signUp");
  }

  Future<void> login(String email, password) async {
    return _authenticate(email, password, "signInWithPassword");
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _email = null;
    _expire = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    SharedPreferences.getInstance().then((prefs) {
      prefs.clear();
    });
    notifyListeners();
  }

  void autoLogout() {
    if (_authTimer != null) _authTimer.cancel();
    _authTimer = Timer(_expire.difference(DateTime.now()), logout);
  }

  String get token {
    if (loggedIn) {
      return _token;
    }
    return null;
  }

  bool get loggedIn {
    return (_expire != null &&
        DateTime.now().isBefore(_expire) &&
        _token != null);
  }
}
