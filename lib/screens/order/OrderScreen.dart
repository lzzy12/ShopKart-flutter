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
    final provider = Provider.of<OrdersProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      drawer: ShopKartDrawer(),
      body: FutureBuilder(
        future: provider.fetch(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          if (snapshot.hasError)
            return Center(
                child: Text(
                    'An error occured! Check your internet connection ${snapshot.error.toString()}'));
          final products = provider.items;
          return products.isEmpty
              ? NoDataWidget()
              : RefreshIndicator(
                  onRefresh: provider.fetch,
                  child: Container(
                    margin: EdgeInsets.all(8),
                    child: ListView.builder(
                        itemCount: products.length,
                        itemBuilder: (context, i) {
                          return OrdersElement(products[i]);
                        }),
                  ),
                );
        },
      ),
    );
  }
}
