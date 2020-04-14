import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/screens/cart/CartProductElement.dart';

import './CartTotalRow.dart';

class CartScreen extends StatelessWidget {
  static const route = "/cart";

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CartProvider>(context);
    final cartList = provider.items;

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Container(
        margin: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            CartTotalRow(),
            Expanded(
              child: ListView.builder(
                  itemCount: cartList.length,
                  itemBuilder: (ctx, i) => CartProductElement(cartList[i])),
            )
          ],
        ),
      ),
    );
  }
}
