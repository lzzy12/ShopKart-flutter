import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/common/ShopKartDrawer.dart';
import 'package:shop_app/models/Data.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/user_products/AddProductBottomSheet.dart';

import './UserProductElement.dart';

class UserProductsScreen extends StatelessWidget {
  static const route = "/user_products";
  ProductsProvider productProvider;

  void onProductEdit(Product newProduct) {
    productProvider.editProducts(newProduct);
  }

  @override
  Widget build(BuildContext context) {
    productProvider = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductFormScreen.route);
            },
          )
        ],
      ),
      drawer: ShopKartDrawer(),
      body: ListView.builder(
          itemCount: productProvider.products.length,
          itemBuilder: (ctx, i) {
            return UserProductElement(productProvider.products[i]);
          }),
    );
  }
}
