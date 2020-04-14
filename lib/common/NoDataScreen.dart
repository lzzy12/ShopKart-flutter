import 'package:flutter/material.dart';

class NoDataWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(children: <Widget>[
        Center(
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Text(
              'Nothing to show here',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ),
        Image.asset(
          'assets/images/waiting.png',
          width: size.width / 5,
        ),
      ]),
    );
  }
}
