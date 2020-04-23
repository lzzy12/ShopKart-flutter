import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/providers/rest/API_KEYS.dart';
import 'package:shop_app/providers/rest/http_exception.dart';

class Auth with ChangeNotifier {
  static const apiKey = FIREBASE_API_KEY;
  String _token;
  DateTime _expire;
  String _userId;
  String _email;

  String get userId => _userId;

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
      _expire = DateTime.now().add(
          Duration(seconds: int.parse(jsonResp['expiresIn'])));
      notifyListeners();
      print(res.body);
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
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, "signUp");
  }

  Future<void> login(String email, password) async {
    return _authenticate(email, password, "signInWithPassword");
  }

  String get token {
    if (loggedIn) {
      return _token;
    }
    return null;
  }

  bool get loggedIn {
    return (_expire != null && DateTime.now().isBefore(_expire) &&
        _token != null);
  }
}
