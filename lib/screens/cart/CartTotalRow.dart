import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/common/snackbar.dart';
import 'package:shop_app/models/Data.dart';
import 'package:shop_app/providers/orders.dart';

import '../../providers/cart.dart';

class CartTotalRow extends StatefulWidget {
  @override
  _CartTotalRowState createState() => _CartTotalRowState();
}

class _CartTotalRowState extends State<CartTotalRow> {
  var ordering = false;

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
                ordering
                    ? Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      )
                    : FlatButton(
                        onPressed: () {
                          setState(() {
                            ordering = true;
                          });
                          orderProvider
                              .addOrder(
                                  Order(cartProvider.items, DateTime.now()))
                              .then((value) {
                            cartProvider.checkout();
                            setState(() {
                              ordering = false;
                            });
                            MySnackBar('Your order has been placed!')
                              ..show(context);
                          }).catchError((_) {
                            MySnackBar(
                                'Request cannot be processed at the moment! Please try again later.')
                              ..show(context);
                          });
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
