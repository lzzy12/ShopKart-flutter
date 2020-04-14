import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/common/snackbar.dart';

import '../../models/Data.dart';
import '../../providers/cart.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const route = "/product-details";

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final product = ModalRoute.of(context).settings.arguments as Product;
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        actions: <Widget>[],
      ),
      body: Container(
        margin: EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Image.network(
                product.imageUrl,
                width: double.infinity,
                height: size.height / 3,
                fit: BoxFit.fill,
              ),
              SizedBox(
                height: 16,
              ),
              ListTile(
                title: Text(
                  product.name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Text('₹ ${product.price}'),
                trailing: IconButton(
                  icon: Icon(
                    Icons.add_shopping_cart,
                    color: Theme
                        .of(context)
                        .accentColor,
                  ),
                  onPressed: () {
                    cartProvider.addProduct(product);
                    MySnackBar('Product added to cart')
                      ..show(context);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
