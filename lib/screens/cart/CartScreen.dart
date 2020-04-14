import 'package:flutter/material.dart';

import './CartTotalRow.dart';

class CartScreen extends StatelessWidget {
  static const route = "/cart";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(16),
          child: Column(
            children: <Widget>[CartTotalRow()],
          ),
        ),
      ),
    );
  }
}
