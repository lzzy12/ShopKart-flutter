import 'package:flutter/material.dart';

Future<void> showError(BuildContext context) async {
  showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
            title: Text('Oops something went wrong'),
            content: Text(
                'There was an error fetching products! Please try again later!'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () => Navigator.of(ctx).pop(),
              )
            ],
          ));
}
