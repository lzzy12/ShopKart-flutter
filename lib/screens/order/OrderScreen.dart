import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/common/NoDataScreen.dart';

import './OrdersElement.dart';
import '../../common/ShopKartDrawer.dart';
import '../../providers/orders.dart';

class OrderScreen extends StatelessWidget {
  static const route = "/cart-screen";

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<OrdersProvider>(context).items;

    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      drawer: ShopKartDrawer(),
      body: products.isEmpty
          ? NoDataWidget()
          : Container(
              margin: EdgeInsets.all(8),
              child: ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, i) {
                    return OrdersElement(products[i]);
                  }),
            ),
    );
  }
}
