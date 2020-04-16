import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/common/snackbar.dart';
import 'package:shop_app/models/Data.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:uuid/uuid.dart';

import '../../providers/cart.dart';

class CartTotalRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final orderProvider = Provider.of<OrdersProvider>(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Total',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Text(
                    '₹ ${cartProvider.amount.toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    orderProvider.addOrder(
                        Order(Uuid().v4(), cartProvider.items, DateTime.now()));
                    cartProvider.checkout();
                    MySnackBar('Your order has been placed!')
                      ..show(context);
                  },
                  child: Text(
                    'Order Now',
                    style: TextStyle(color: Colors.blue),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
