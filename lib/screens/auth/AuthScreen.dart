import 'package:flutter/material.dart';
import 'package:shop_app/screens/auth/BrandingBox.dart';

import './AuthenticationBox.dart';

class AuthScreen extends StatelessWidget {
  static const route = "/auth";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.cyan, Colors.cyanAccent],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight),
        ),
        child: ListView(
          children: <Widget>[
            BrandingBox(),
            AuthenticationBox(),
          ],
        ),
      ),
    );
  }
}
