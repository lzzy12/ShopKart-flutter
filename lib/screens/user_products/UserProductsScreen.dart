import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/common/NoDataScreen.dart';
import 'package:shop_app/common/ShopKartDrawer.dart';
import 'package:shop_app/common/snackbar.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/user_products/EditProductFormScreen.dart';

import './UserProductElement.dart';

class UserProductsScreen extends StatefulWidget {
  static const route = "/user_products";

  @override
  _UserProductsScreenState createState() => _UserProductsScreenState();
}

class _UserProductsScreenState extends State<UserProductsScreen> {
  Future<void> fetchProducts() async {
    final productProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    await productProvider.fetch(filter: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(EditProductFormScreen.route)
                  .then((data) {
                if (data != null) MySnackBar('Product added')
                  ..show(context);
              });
            },
          )
        ],
      ),
      drawer: ShopKartDrawer(),
      body: FutureBuilder(
        future: fetchProducts(),
        builder: (ctx, snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Text(
                    'An error occured! Check your internet and try again later!'));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final productProvider = Provider.of<ProductsProvider>(context);
          return RefreshIndicator(
            onRefresh: () => productProvider.fetch(filter: true),
            child: productProvider.products.isEmpty
                ? NoDataWidget()
                : ListView.builder(
                itemCount: productProvider.products.length,
                itemBuilder: (ctx, i) {
                  return UserProductElement(productProvider.products[i]);
                }),
          );
        },
      ),
    );
  }
}
