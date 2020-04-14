import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class MySnackBar extends Flushbar {
  final String message;

  MySnackBar(this.message)
      : super(
            message: message,
            icon: Icon(
              Icons.info_outline,
              size: 28.0,
              color: Colors.blue[300],
            ),
            leftBarIndicatorColor: Colors.blue[300],
            duration: Duration(seconds: 5));
}
