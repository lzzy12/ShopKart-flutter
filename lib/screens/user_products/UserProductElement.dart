import 'package:flutter/material.dart';
import 'package:shop_app/models/Data.dart';
import 'package:shop_app/screens/user_products/AddProductBottomSheet.dart';

import '../product_details/ProductDetailsScreen.dart';

class UserProductElement extends StatelessWidget {
  final Product product;

  UserProductElement(this.product);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          onTap: () => Navigator.of(context)
              .pushNamed(ProductDetailsScreen.route, arguments: product),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              product.imageUrl,
              height: 56,
              width: 56,
              fit: BoxFit.contain,
            ),
          ),
          title: Text(product.name),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => Navigator.of(context)
                    .pushNamed(EditProductFormScreen.route, arguments: product),
              ),
              IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () {},
              )
            ],
          ),
        ),
      ),
    );
  }
}
